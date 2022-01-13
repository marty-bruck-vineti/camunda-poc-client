Rails.application.routes.draw do
  root 'workflows#index'
  resources :workflows, :patients, :orders
end
