Rails.application.routes.draw do
  root "pages#home"
  get 'pages/home', to: 'pages#home'
  
  # get '/recipes', to: 'recipes#index'
  # new route needs to be above show - otherwise it is confused with :id
  # get '/recipes/new', to: 'recipes#new', as: 'new_recipe'
  # get '/recipes/:id', to: 'recipes#show', as: 'recipe'
  # post '/recipes', to: 'recipes#create'
  # Replace all the above with "resources :recipes"
  resources :recipes do
    # Nested route here - comments are under recipes
    resources :comments, only: [:create, :destroy]
    resources :likes, only: [:create, :destroy]
  end
  get '/signup', to: 'chefs#new'
  resources :chefs, except: [:new]
  resources :ingredients
  
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  mount ActionCable.server => '/cable'
  get '/chat', to: 'chefchats#show'
  resources :messages, only: [:create]
end
