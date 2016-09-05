Rails.application.routes.draw do
  resources :charts
  devise_for :users
  root "high_voltage/pages#show", id: 'index'
end
