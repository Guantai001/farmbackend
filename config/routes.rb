Rails.application.routes.draw do

  #LOGIN ROUTES
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

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

  # MILK ROUTES
  get "/milks", to: "milks#index"
  get "/milks/:id", to: "milks#show"
  post "/milk", to: "milks#create"
  patch "/milks/:id", to: "milks#update"
  delete "/milks/:id", to: "milks#destroy"
  get "/milks/:id/milk_kgs", to: "milks#milk_kgs"
  get "/milk/total", to: "milks#total"
  get "/milk/:id/total_animal", to: "milks#total_animal"
  get "/sort_by_month", to: "milks#sort_by_month"
  get "/admin_milk", to: "milks#admin_milk"
  # DAIRY_SELL ROUTES
  get "/sells", to: "dairy_sells#index"
  get "/sells/:id", to: "dairy_sells#show"
  post "/sell", to: "dairy_sells#create"
  patch "/sells/:id", to: "dairy_sells#update"
  delete "/sells/:id", to: "dairy_sells#destroy"
  get "/sells/:id/total", to: "dairy_sells#sold_price"
  get "/sell/total", to: "dairy_sells#total"
  get "/monthly_sell", to: "dairy_sells#sort_sells_by_month"
  get "admin_sell", to: "dairy_sells#admin_totals"

  # DAIRY_COST ROUTES
  get "/costs", to: "dairy_costs#index"
  get "/costs/:id", to: "dairy_costs#show"
  post "/cost", to: "dairy_costs#create"
  patch "/costs/:id", to: "dairy_costs#update"
  delete "/costs/:id", to: "dairy_costs#destroy"
  get "/costs/:id/total", to: "dairy_costs#cost_price"
  get "/cost/total", to: "dairy_costs#total"
  get "admin_cost", to: "dairy_costs#admin_totals"

  # MILK_PRICE ROUTES
  get "/prices", to: "milk_prices#index"
  get "/prices/:id", to: "milk_prices#show"
  post "/prices", to: "milk_prices#create"
  patch "/prices/:id", to: "milk_prices#update"
  delete "/prices/:id", to: "milk_prices#destroy"
end
