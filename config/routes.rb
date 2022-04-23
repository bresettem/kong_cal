Rails.application.routes.draw do
  devise_for :users
  resource :user, shallow: true do
    resources :claims
    resources :goals
    resources :tribe_items do
      member do
        get 'individual_item'
      end
    end
    get '/total_tribes', to: 'tribe_items#total_tribes'
  end
  get '/update_alpha', to: 'alpha_coin#update_alpha_coin'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  root "landing#index"
end