Rails.application.routes.draw do
  resources :forge_items
  resources :skill_levels
  resources :levels
  resources :monster_items
  resources :skills
  resources :items
  resources :equipables
  resources :monsters
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
