require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  post '/sign_in', to: 'user_token#create'
  post '/create', to: 'users#create'
  patch '/update', to: 'users#update'

  resources :properties, only: %i[index show create update destroy]

  resources :bookings, only: %i[index show create]
  patch '/bookings/:id/cancel', to: 'bookings#cancel'
  patch '/bookings/:id/confirm', to: 'bookings#confirm'
  patch '/bookings/:id/decline', to: 'bookings#decline'

  resources :payments, only: %i[index show]
  patch '/payments/:id/pay', to: 'payments#pay'
  patch '/payments/:id/reject', to: 'payments#reject'

  resources :chats, only: %i[index show]
  get '/chats/:id/messages', to: 'chats#messages'

  post '/chats/:id/messages', to: 'messages#create'

  get '/photos', to: 'photos#index'
  post '/photos', to: 'photos#create'
end
