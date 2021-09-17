class Api::V1::UsersController < ApplicationController

  def facebook
    if params[:facebook_access_token]
      graph = Koala::Facebook::API.new(params[:facebook_access_token])
      profile = graph.get_object("me?fields=id,name,email,picture")

      user = User.find_by(email: profile["email"])
      if user.present?
        user.generate_new_authentication_token
        json_response("User information", true, {user: user}, :ok)
      else
        user = User.new(email: profile["email"],
                        uid: profile["uid"],
                        provider: "facebook",
                        image: profile["picture"]["data"]["url"],
                        password: Devise.friendly_token[0,20])

        user.authentication_token = User.generate_unique_secure_token
        if user.save
          json_response("Login Facebook Successfully", true, {user: user}, :ok)
        else
          json_response(user.errors.full_messages, false, {}, :unprocessable_entity)
        end
      end
    else
      json_response("Missing facebook access token", false, {}, :unprocessable_entity)
    end
  end
end