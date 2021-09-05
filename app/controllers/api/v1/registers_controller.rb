class Api::V1::RegistersController < Devise::RegistersController
  before_action :ensure_user_params_exist, only: [:create]

  # user sign_up feature
  def create
    user = User.new(user_params)
    if user.save
      render json: {
        messages: "Sign Up Successfully!",
        is_success: true,
        data: {
          user: user
        }
      }, status: :ok
    else
      render json: {
        messages: "Something Wrong!",
        is_success: false,
        data: {}
      }, status: :unprocessable_entity
    end
  end

  private
  
  # need a method to return user params from client(only allow client to send request with only: email, password, password_confirmation)
  def user_params
    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation
    )
  end

  # check the user params whether it exist or not before client sign_up
  def ensure_user_params_exist
    return if params[:user].present?
    render json: {
      messages: "Missing params",
      is_success: false,
      data: {}
    }, status: :bad_request
  end
end