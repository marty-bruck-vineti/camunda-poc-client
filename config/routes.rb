Rails.application.routes.draw do
  root 'workflow#index'
  get 'workflow/index', to: 'workflow#index'
  get 'workflow/new', to: 'workflow#new'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
