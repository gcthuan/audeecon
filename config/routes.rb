Rails.application.routes.draw do
  root 'pages#home'
  #api v1
  match '/api/v1/packs/initialize', to: 'api/v1/packs#initialize_database', via: 'get'
  match '/api/v1/packs/demo', to: 'api/v1/packs#demo', via: 'get'
  match '/api/v1/users/:username', to: 'api/v1/users#show', via: 'get'
  match '/api/v1/users/:username/purchase', to: 'api/v1/users#purchase', via: 'post'
  match '/api/v1/users/:username/packs', to: 'api/v1/users#show_packs', via: 'get'
  match '/api/v1/packs/:id/:sticker_id', to: 'api/v1/packs#get_sticker', via: 'get'
  #api v2
  match '/api/v2/packs/initialize', to: 'api/v2/packs#initialize_database', via: 'get'
  match '/api/v2/categories/initialize', to: 'api/v2/categories#initialize_categories_database', via: 'get'
  match '/api/v2/packs/demo', to: 'api/v2/packs#demo', via: 'get'
  match '/api/v2/users/:username', to: 'api/v2/users#show', via: 'get'
  match '/api/v2/users/:username/purchase', to: 'api/v2/users#purchase', via: 'post'
  match '/api/v2/users/:username/purchase', to: 'api/v2/users#unpurchase', via: 'put'
  match '/api/v2/users/:username/packs', to: 'api/v2/users#show_packs', via: 'get'
  match '/api/v2/users/:username/recommend', to: 'api/v2/users#recommend', via: 'post'
  match '/api/v2/users/:username/recommend', to: 'api/v2/users#show_latest_recommendation', via: 'get'
  match '/api/v2/packs/:id/:sticker_id', to: 'api/v2/packs#get_sticker', via: 'get'
  match '/api/v2/categories/:name', to: 'api/v2/categories#show', via: 'get'

  ##
  namespace :api do
    namespace :v1 do

      resources :stickers, :packs, :users
    end

    namespace :v2 do

      resources :stickers, :packs, :users, :categories
    end

  end

  match '/about', to: 'pages#about', via: 'get'
  match '/api-list', to: 'pages#api_list', via: 'get'
  match '/demo', to: 'pages#demo', via: 'get'
  match '/features', to: 'pages#features', via: 'get'
end
