class UsersController < ApplicationController
  before_action :authenticate_user, except: [:create, :create_password_reset, :password_reset]
  before_action :set_user, only: [:show, :update, :destroy, :email_confirm]
  before_action :authorize_user, only: [:show, :update, :destroy, :email_confirm]


  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # GET /users/me
  def me
    render json: current_user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user, status: :unprocessable_entity, adapter: :json_api, serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params_for_update)
      render json: @user
    else
      render json: @user, status: :unprocessable_entity, adapter: :json_api, serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end

  # DELETE /users/1
  def destroy
    if current_user.role >= @user.role
      @user.destroy
    else
      render status: :forbidden
    end
  end

  # password reset
  def create_password_reset
    @user = User.where(email: user_params_for_password_reset[:email]).first
    password_reset_token = User.generate_token
    if(@user and @user.update(password_reset_token: password_reset_token))
      UserMailer.password_reset(@user).deliver_later
    end
  end

  def password_reset
    token = user_params_for_password_reset[:password_reset_token]
    users = User.where(password_reset_token: token)
    render status: :not_found and return if token.nil? or users.empty? or users.size != 1

    @user = users.first
    unless @user.update(password: user_params_for_password_reset[:password], password_reset_token: nil)
      render json: @user, status: :unprocessable_entity, adapter: :json_api, serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end

  def email_confirm
    token = user_params_for_email_confirm[:email_confirm_token]

    render status: :forbidden and return if token.nil? or @user.email_confirm_token != token

    if @user.update(email_confirm_token: nil)
      render json: @user
    else
      render json: @user, status: :unprocessable_entity, adapter: :json_api, serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      begin
        @user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        authorize_user and raise e
      end
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      allowed_params = ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:email, :password, :role])
      if(allowed_params[:role])
        allowed_params[:role] = [allowed_params[:role].to_i, current_user.role].min
      end

      allowed_params
    end

    def user_params_for_update
      # only a user can change its own credentials
      allowed_params = current_user == @user ? user_params : user_params.except(:email, :password)

      if(current_user.role < @user.role)
        allowed_params.except!(:role)
      end

      allowed_params
    end

    def user_params_for_password_reset
      ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:email, :password, :'password-reset-token'], keys: { :'password-reset-token' => :password_reset_token })
    end

    def user_params_for_email_confirm
      ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: :'email-confirm-token', keys: { :'email-confirm-token' => :email_confirm_token})
    end

    def authorize_user
      (render status: :forbidden and return false) unless current_user.is_user_manager? or @user == current_user

      return true
    end
end
