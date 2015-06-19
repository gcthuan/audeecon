Rails.application.routes.draw do
  match '/api/v1/packs/initialize', to: 'api/v1/packs#initialize_database', via: 'get'
  match '/api/v1/packs/demo', to: 'api/v1/packs#demo', via: 'get'
  match '/api/v1/users/:username', to: 'api/v1/users#show', via: 'get'
  match '/api/v1/users/:username/purchase', to: 'api/v1/users#purchase', via: 'post'
  match '/api/v1/packs/:id/:sticker_id', to: 'api/v1/packs#get_sticker', via: 'get'
  namespace :api do
    namespace :v1 do

      resources :stickers, :packs, :users
    end

  end
end
