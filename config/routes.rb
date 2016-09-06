Rails.application.routes.draw do
  resources :charts, except: [:index]
  devise_for :users
  root "charts#index"
end
