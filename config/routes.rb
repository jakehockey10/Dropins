Rails.application.routes.draw do
  root 'static_pages#home'
  get 'about' => 'static_pages#about'
  get 'calendar' => 'static_pages#calendar'
  get 'contact' => 'contact_with_messages#new'
  get 'signup' => 'users#new'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  match '/oauth2callback', to: 'invite#oauth2callback', via: 'get'
  match '/contacts/failure', to: 'invite#failure', via: 'get'
  notify_to :users, with_subscription: true
  resources :users do
    get :autocomplete_gmail_contact_name, on: :collection
    member do
      get :following, :followers
      get :show_avatar
      get :upload_avatar
      delete :delete_avatar
    end
  end

  get '/users/:action(/:user_id)', controller: 'users' # For WePay:
  resources :account_activations, only: [:edit]
  resources :password_resets, only: %i[new create edit update]
  resources :help_requests, only: %i[new create]
  resources :dropin_creator_emails, only: [:create]
  resources :dropin_removal_requests, only: %i[create edit]
  resources :microposts, only: %i[create destroy]
  resources :relationships, only: %i[create destroy]
  resources :contact_with_messages, only: %i[new create]
  resources :conversations, only: %i[index show new create] do
    member do
      post :reply
      post :trash
      post :untrash
    end
  end

  # Uncomment when these are actually ready!
  resources :groups
  resources :group_invites

  get 'invite/invite'

  resources :attendances, only: %i[create destroy]
  resources :dropins do
    member do
      get :pay, :payment_success
      post :email_attendees
    end
  end
  resources :rinks
end
