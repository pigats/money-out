Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  scope 'api', defaults: { format: 'json' } do
    get 'users/me' => 'users#me'
    resources :users do
      resources :expenses, shallow: true
    end
    post 'session' => 'user_token#create'
  end

  mount_ember_app :client, to: '/'
end
