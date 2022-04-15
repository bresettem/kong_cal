Rails.application.routes.draw do
  resources :tribe_items do
    member do
      get 'tables'
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get '/total_tribes', to: 'tribe_items#total_tribes'
  get '/days_until', to: 'tribe_items#days_until', as: 'calculate_days'
  # Defines the root path route ("/")
  root "tribe_items#index"
end