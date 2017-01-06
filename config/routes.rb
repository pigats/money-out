Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  scope 'api', defaults: { format: 'json' } do
    post 'session' => 'user_token#create'
    get 'users/me' => 'users#me'
    resources :users
  end

  mount_ember_app :client, to: '/'
end
