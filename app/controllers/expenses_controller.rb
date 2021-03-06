# Handles requests for Expense information
# The following resources were helpful when writing this controller:
# https://stackoverflow.com/questions/14824551/rendering-json-in-controller/14824660
# https://stackoverflow.com/questions/15397537/rails-model-to-hash-exclude-attributes
class ExpensesController < ApplicationController
    before_action :set_user
    before_action :set_user_post, only: [:show, :update, :destroy]

    def index
        render json: @user.expenses.as_json(:except => [:user_id, :category_id], :include => :category)
    end

    def show
        render json: @expense.as_json(:except => [:user_id, :category_id], :include => :category)
    end

    def create
        @user.expenses.create!(expense_params)
        json_response(@user, :created)
    end

    def update
        @expense.update(expense_params)
        head :no_content
    end

    def destroy
        @expense.destroy
        head :no_content
    end

    private
        def expense_params
            params.permit(:id, :name, :amount, :expense_date, :user_id, :category_id)
        end

        def set_user
            @user = User.find(params[:user_id])
            if !authorized_user?
                json_response("You cannot do that.", 401);
            end
        end

        def set_user_post
            @expense = @user.expenses.find_by!(id: params[:id])
        end
end
