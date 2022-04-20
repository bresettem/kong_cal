Rails.application.routes.draw do
  resources :goals
  resources :tribe_items do
    member do
      get 'tables'
    end
  end
  get '/update_alpha', to: 'alpha_coin#update_alpha_coin'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get '/total_tribes', to: 'tribe_items#total_tribes'
  # Defines the root path route ("/")
  root "tribe_items#index"
end