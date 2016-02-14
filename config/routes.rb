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
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :help_requests, only: [:new, :create]
  resources :dropin_creator_emails, only: [:create]
  resources :dropin_removal_requests, only: [:create, :edit]
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :contact_with_messages, only: [:new, :create]
  resources :conversations, only: [:index, :show, :new, :create] do
    member do
      post :reply
      post :trash
      post :untrash
    end
  end

  # Uncomment when these are actually ready!
  resources :groups

  get 'invite/invite'

  resources :attendances, only: [:create, :destroy]
  resources :dropins do
    member do
      get :pay, :payment_success
      post :email_attendees
    end
  end
  resources :rinks

end
