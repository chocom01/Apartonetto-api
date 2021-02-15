Rails.application.routes.draw do
  post '/sign_in', to: 'user_token#sign_in'
  post '/create', to: 'users#create'
  patch '/update', to: 'users#update'

  resources :properties, only: %i[index show create update destroy]

  resources :bookings, only: %i[index show create update]
  patch '/bookings/:id/cancel', to: 'bookings#cancel'
  patch '/bookings/:id/confirm', to: 'bookings#confirm'
  patch '/bookings/:id/declin', to: 'bookings#declin'

  resources :payments, only: %i[index show]
  patch '/payments/:id/pay', to: 'payments#pay'
  patch '/payments/:id/reject', to: 'payments#reject'

  resources :chats, only: %i[index show update]
  get '/chats/:id/messages', to: 'chats#messages'

  post '/chats/:id/messages', to: 'messages#create'
end
