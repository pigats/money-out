class ExpensesController < ApplicationController
  before_action :authenticate_user
  before_action :authorize_user, only: [:index, :create]
  before_action :set_expense, only: [:show, :update, :destroy]
  before_action :set_user, only: :create

  # GET /expenses
  def index
    @expenses = Expense.where user_id: params[:user_id]

    render json: @expenses
  end

  # GET /expenses/1
  def show
    render json: @expense
  end

  # POST /expenses
  def create
    @expense = Expense.new(expense_params.merge(user_id: params[:user_id]))
    p @expense
    p expense_params

    if @expense.save
      render json: @expense, status: :created, location: user_expenses_url(@user, @expense)
    else
      render json: @expense, status: :unprocessable_entity, adapter: :json_api, serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end

  # PATCH/PUT /expenses/1
  def update
    if @expense.update(expense_params)
      render json: @expense
    else
      render json: @expense, status: :unprocessable_entity, adapter: :json_api, serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end

  # DELETE /expenses/1
  def destroy
    @expense.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      begin
        @expense = Expense.where(id: params[:id]).first!
      rescue ActiveRecord::RecordNotFound => e
        authorize_user and raise e
      end
      authorize_user
    end

    # Only allow a trusted parameter "white list" through.
    def expense_params
      ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:date, :description, :amount, :comment])
    end

    def authorize_user
      (render status: :unauthorized and return false) unless current_user.is_admin or
                                                              (params[:user_id] and params[:user_id].to_i == current_user.id) or
                                                              (@expense and @expense.user == current_user)

      return true
    end

    def set_user
      @user = User.find(params[:user_id])
    end
end
