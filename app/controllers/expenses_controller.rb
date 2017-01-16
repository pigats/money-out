class ExpensesController < ApplicationController
  before_action :authenticate_user
  before_action :set_expense, only: [:show, :update, :destroy]
  before_action :authorize_user

  # GET /api/expenses
  def all
    @expenses = Expense.all.reorder('user_id ASC, created_at DESC')

    render json: @expenses, meta: compute_stats
  end

  # GET /api/users/:id/expenses
  def index

    if(params[:date] and params[:date][:from] and params[:date][:to])
      date_from = DateTime.parse(params[:date][:from])
      date_to = DateTime.parse(params[:date][:to])
      dates = (date_from..date_to) unless date_from > date_to
    end
    if(params[:amount] and params[:amount][:from] and params[:amount][:to])
      amount_from = params[:amount][:from]
      amount_to = params[:amount][:to]
      amounts = (amount_from..amount_to) unless amount_from > amount_to
    end

    @expenses = Expense.of_user(params[:user_id]).dates_between(dates).amount_between(amounts).description_like(params[:description])

    render json: @expenses, meta: compute_stats(dates)
  end

  # GET /api/users/:id/expenses/:id
  def show
    render json: @expense
  end

  # POST /api/users/:id/expenses
  def create
    user = User.find(params[:user_id])
    @expense = Expense.new(expense_params.merge(user: user))

    if @expense.save
      render json: @expense, status: :created, location: user_expenses_url(user, @expense)
    else
      render json: @expense, status: :unprocessable_entity, adapter: :json_api, serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end

  # PATCH /api/users/:id/expenses/:id
  def update
    if @expense.update(expense_params)
      render json: @expense
    else
      render json: @expense, status: :unprocessable_entity, adapter: :json_api, serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end

  # DELETE /api/users/:id/expenses/:id
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
    end

    # Only allow a trusted parameter "white list" through.
    def expense_params
      allowed_params = ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:date, :description, :amount, :comment, :user])
      current_user.is_admin? ? allowed_params : allowed_params.except(:user_id)
    end

    def authorize_user
      (render status: :forbidden and return false) unless current_user.is_admin? or
                                                              (params[:user_id] and params[:user_id].to_i == current_user.id) or
                                                              (@expense and @expense.user == current_user)

      return true
    end

    def set_user
    end

    def compute_stats dates = nil
      stats = {
        total_expense: @expenses.map(&:amount).inject(0, :+)
      }

      if(dates)
        stats[:number_of_days] = [[dates.max, dates.min].map(&:to_date).inject(:-).to_i, 1].max
        stats[:average_daily_expense] = stats[:total_expense] / stats[:number_of_days]
      end

      return stats
    end
end
