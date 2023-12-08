Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get "/api/v0/markets/search", to: "api/v0/markets/search#index"

  namespace :api do
    namespace :v0 do
      resources :markets, only: [:index, :show] do
        resources :vendors, only: [:index], controller: "markets/vendors"
        resources :nearest_atms, only: [:index], controller: 'markets/nearest_atms'
      end
      
      resources :vendors, only: [:show, :create, :destroy, :update]

      resources :market_vendors, only: [:create]
      delete '/market_vendors', to: 'market_vendors#destroy'
    end
  end
end
