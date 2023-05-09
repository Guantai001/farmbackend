Rails.application.routes.draw do
  # resources :cows
  # resources :admins
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get "latest", to: "admins#latest"

    #ADMIN ROUTES
    get "/admins", to: "admins#index"
    get "/admins/:id", to: "admins#show"
    post "/admins", to: "admins#create"
    patch "/admins/:id", to: "admins#update"
    delete "/admins/:id", to: "admins#destroy"
  
    #COW ROUTES
    get "/cows", to: "cows#index"
    get "/cows/:id", to: "cows#show"
    post "/cows", to: "cows#create"
    patch "/cows/:id", to: "cows#update"
    delete "/cows/:id", to: "cows#destroy"

end
