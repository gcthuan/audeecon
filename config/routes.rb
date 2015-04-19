Rails.application.routes.draw do
  match '/api/v1/packs/initialize', to: 'api/v1/packs#initialize_database', via: 'get'
  namespace :api do
    namespace :v1 do

      resources :stickers, :packs
    end

  end
end
