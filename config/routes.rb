Rails.application.routes.draw do
  resources :equips
  resources :monsters
  resources :elements
  resources :locations
  resources :areas
  resources :items
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "monsters#index"
end
