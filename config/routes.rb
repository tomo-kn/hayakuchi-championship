Rails.application.routes.draw do
  root 'pages#index'
  get '/policy', to: 'pages#policy'
  get '/contact', to: 'pages#contact'
  get '/terms', to: 'pages#terms'
  get '/how-to-play', to: 'pages#how_to_play'
  get '/game', to: 'games#index'
  get '/game/result', to: 'games#result'
  get '/practices', to: 'practices#index'
  get '/rank', to: 'ranks#index'
  
  namespace :api do
    namespace :v1 do
      get :health_check, to: 'health_check#index'
    end
  end
end
