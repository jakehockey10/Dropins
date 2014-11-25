Rails.application.routes.draw do
  resources :conversations, only: [:index, :show, :new, :create] do
    member do
      post :reply
      post :trash
      post :untrash
    end
  end

  get 'invite/invite'
  get 'commitments/create'
  get 'commitments/destroy'
  resources :users do
    # get :autocomplete_gmail_contact_email, on: :collection
    get :autocomplete_gmail_contact_name, on: :collection
    member do
      get :following, :followers
      get :verify_emails
      get :show_avatar
      get :upload_avatar
      match :delete_avatar, via: :delete
    end
  end
  # For WePay:
  get '/users/:action(/:user_id)', controller: 'users'

  resources :sessions, only: [:new, :create, :destroy]
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :password_resets
  resources :contact_with_messages, only: [:new, :create]
  resources :attendances, only: [:create, :destroy]
  resources :dropins do
    member do
      get :pay, :payment_success
    end
  end
  resources :rinks

  root 'static_pages#home'

  match '/signup', to: 'users#new', via: 'get'
  match '/signin', to: 'sessions#new', via: 'get'
  match '/signout', to: 'sessions#destroy', via: 'delete'

  match '/help', to: 'static_pages#help', via: 'get'
  match '/about', to: 'static_pages#about', via: 'get'
  match '/contact', to: 'contact_with_messages#new', via: 'get'
  match '/oauth2callback', to: 'invite#oauth2callback', via: 'get'
  # match '/contacts/:importer/callback', to: 'invite#oauth2callback', via: 'get'
  match '/contacts/failure', to: 'invite#failure', via: 'get'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
