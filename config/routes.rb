Rails.application.routes.draw do
  get 'messages/index'
  root 'workflows#index'
  delete 'messages' => 'messages#clear'
  resources :workflows, :patients, :orders, :messages

end
