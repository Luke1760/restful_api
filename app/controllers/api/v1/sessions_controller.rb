class Api::V1::SessionsController < Devise::SessionsController
  before_action :sign_in_params, only: [:create]
  before_action :confirm_if_user_exists, only: [:create]
  before_action :valid_token, only: [:destroy]
  skip_before_action :verify_signed_out_user, only: [:destroy]
  
  # user sign_in feature
  def create
    if @user.valid_password?(sign_in_params[:password])
      sign_in(:user, @user)
      json_response("Signed In Successfully!", true, @user, :ok)
    else
      json_response("Unauthorized", false, {}, :unauthorized)
    end
  end
  # user sign_out feature
  def destroy
    sign_out @user
    @user = User.generate_unique_secure_token
    json_response("Sign Out Successfully!", true, {}, :ok)
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

  def valid_token
    @user = User.find_by(authentication_token: request.headers["AUTH-TOKEN"])
    if @user.present?
      return @user
    else
      json_response("Invalid Token", false, {}, :failure)
    end
  end

end