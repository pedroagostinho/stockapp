Rails.application.routes.draw do
  devise_for :users
  root to: 'stocks#my_stocks'

  resources :stocks, only: [:index]
  resources :user_stocks, only: [:destroy]

  get 'stocks/my_stocks', to: "stocks#my_stocks", as: "my_stocks"
  get 'stocks/add_stock'
  get 'stocks/refresh_stock'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
