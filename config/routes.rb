Rails.application.routes.draw do
  devise_for :users
  root to: 'stocks#my_stocks'

  resources :stocks, only: [:index]
  get 'stocks/my_stocks', to: "stocks#my_stocks", as: "my_stocks"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
