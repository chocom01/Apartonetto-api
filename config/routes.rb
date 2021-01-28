Rails.application.routes.draw do
  post 'sign_in' => 'user_token#sign_in'
  post 'sign_up' => 'user_token#sign_up'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
