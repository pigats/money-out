Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount_ember_app :client, to: '/'

  get 'users/me' => 'users#me'
  resources :users, constraints: { format: 'json' }
  post 'session' => 'user_token#create'
end
