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
  get "/last", to: "milk_prices#latest"
  get "/profit_loss", to: "milk_prices#profit_loss"

  # TEA_PRICE ROUTES
  get "/tea_prices", to: "tea_prices#index"
  get "/tea_prices/:id", to: "tea_prices#show"
  post "/tea_prices", to: "tea_prices#create"
  patch "/tea_prices/:id", to: "tea_prices#update"
  delete "/tea_prices/:id", to: "tea_prices#destroy"
  get "/tea_last", to: "tea_prices#latest"

  # TEA_PICK ROUTES
  get "/tea_picks", to: "tea_picks#index"
  get "/tea_picks/:id", to: "tea_picks#show"
  post "/tea_picks", to: "tea_picks#create"
  patch "/tea_picks/:id", to: "tea_picks#update"
  delete "/tea_picks/:id", to: "tea_picks#destroy"
  get "/total", to: "tea_picks#last_one_month"
  get "/last_month", to: "tea_picks#last_month"

  #TEA ROUTES
  get "/tea", to: "teas#index"
  get "/tea/:id", to: "teas#show"
  post "/tea", to: "teas#create"
  patch "/tea/:id", to: "teas#update"
  delete "/tea/:id", to: "teas#destroy"
end
