class Api::V1::SessionsController < Devise::SessionsController
  before_action :sign_in_params, only: [:create]
  before_action :confirm_if_user_exists, only: [:create]
  
  # user sign_in feature
  def create
    if @user.valid_password?(sign_in_params[:password])
      sign_in(:user, @user)
      json_response("Signed In Successfully!", true, @user, :ok)
    else
      json_response("Unauthorized", false, {}, :unauthorized)
    end
  end

  private

  def sign_in_params
    params.require(:sign_in).permit(:email, :password)
  end

  def confirm_if_user_exists
    @user = User.find_for_database_authentication(email: sign_in_params[:email])
    if @user.present?
      return @user
    else
      # Because it is to confirm whether the user exists, but the http protocol has no related error code, so here replace it with failure.
      # but would get Unrecognized status code error.
      json_response("Cannot get user!", false, {}, :failure)
    end
  end
end