class Api::V1::RegistersController < Devise::RegistrationsController
  before_action :ensure_user_params_exist, only: [:create]

  # user sign_up feature
  def create
    user = User.new(user_params)
    if user.save
      json_response("Sign Up Successfully!", true, {user: user}, :ok)
    else
      json_response("Something Wrong!", false, {}, :unprocessable_entity)
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
    json_response("Missing params", false, {}, :bad_request)
  end
end