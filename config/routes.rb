Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      namespace :widget do
        resources :available_rooms, only: :index, defaults: { format: :json }
      end
    end
  end
end
