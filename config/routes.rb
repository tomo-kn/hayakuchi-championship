Rails.application.routes.draw do
  root 'pages#index'
  get '/policy', to: 'pages#policy'
  get '/contact', to: 'pages#contact'
  get '/terms', to: 'pages#terms'

  get '/game', to: 'games#index'
  post '/game', to: 'games#create'
  delete '/games/:id', to: 'games#destroy'

  get '/practices', to: 'practices#index'
  get '/practices/:id', to: 'practices#show', as: 'practice'
  post '/practices/:id', to: 'practices#create'
  get '/results/:id', to: 'practices#result'
  delete 'results/:id', to: 'practices#destroy'

  get '/rank', to: 'ranks#index'

  resources :users, only: %i[new create show edit update]

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  post '/guest_sign_in', to: 'sessions#guest_sign_in'

  namespace :api do
    namespace :v1 do
      get :health_check, to: 'health_check#index'
    end
  end
end
