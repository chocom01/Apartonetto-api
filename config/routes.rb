Rails.application.routes.draw do
  post '/sign_in', to: 'user_token#sign_in'
  post '/sign_up', to: 'user_token#sign_up'
  patch '/update', to: 'users#update'

  resources :properties, only: %i[index show create update destroy]

  resources :bookings, only: %i[index show create update destroy]
  patch '/bookings/:id/cancel', to: 'bookings#cancel'
  patch '/bookings/:id/confirm', to: 'bookings#confirm'
  patch '/bookings/:id/declin', to: 'bookings#declin'

  resources :payments, only: %i[index show create update destroy]
  patch '/payments/:id/pay', to: 'payments#pay'
  patch '/payments/:id/reject', to: 'payments#reject'
  # resources :users, only: %i[index update]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
