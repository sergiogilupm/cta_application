Rails.application.routes.draw do
  resources :trains
  resources :lines
  resources :stations
  root 'stations#index'
# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
