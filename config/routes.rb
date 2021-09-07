Rails.application.routes.draw do
  devise_for :users
  
  # api/v1/your_path
  namespace :api, defaults: {format: :json} do 
    namespace :v1 do 
      devise_scope :user do
        post "sign_up", to: "registers#create"
        post "sign_in", to: "sessions#create"
      end
    end
  end
end
