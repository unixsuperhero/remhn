Rails.application.routes.draw do
  resources :monster_terrains
  resources :item_sources
  resources :monster_elements
  resources :weaknesses
  resources :locations
  resources :terrains
  resources :elements
  resources :stars
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
