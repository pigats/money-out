Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  scope 'api', defaults: { format: 'json' } do
    get 'users/me' => 'users#me'
    # password reset
    post 'users/password-reset' => 'users#create_password_reset'
    patch 'users/password-reset' => 'users#password_reset'
    # email confirm
    patch 'users/:id/confirm' => 'users#email_confirm'

    resources :users do
      resources :expenses, shallow: true
    end

    get 'expenses' => 'expenses#all'
    post 'session' => 'user_token#create'
  end

  mount_ember_app :client, to: '/'
end
