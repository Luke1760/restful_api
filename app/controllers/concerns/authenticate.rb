module Authenticate
  
  def current_user
    auth_token = request.headers["AUTH-TOKEN"]
    return unless auth_token

    @current_user = User.find_by(authentication_token: auth_token)
  end

  def authentication_with_token!
    return if current_user.present?
    json_response("Unauthenticated", false, {}, :unauthorized)
  end

  # the user who rating should the same with current_user
  def check_user_correct(user)
    user.id == current_user.id
  end
end