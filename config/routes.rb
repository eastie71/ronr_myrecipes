Rails.application.routes.draw do
  root "pages#home"
  get 'pages/home', to: 'pages#home'
  
  # get '/recipes', to: 'recipes#index'
  # new route needs to be above show - otherwise it is confused with :id
  # get '/recipes/new', to: 'recipes#new', as: 'new_recipe'
  # get '/recipes/:id', to: 'recipes#show', as: 'recipe'
  # post '/recipes', to: 'recipes#create'
  # Replace all the above with "resources :recipes"
  resources :recipes
end
