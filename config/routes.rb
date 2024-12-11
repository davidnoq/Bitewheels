Rails.application.routes.draw do

 
  # Devise routes for User authentication
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  # Define a Devise scope for the apply_to_event route
  
  # Routes for Events
  resources :events do
    member do
      patch :publish
      patch :complete
    end
    collection do
      get :search
      get :completed
      get :all
    end

    # Nested routes for Event Applications specific to events
    resources :event_applications, only: [:index, :new, :create, :show] do
      member do
        patch :approve
        patch :reject
      end
    end
  end

  # Top-level routes for Event Applications
  resources :event_applications, only: [:index, :show] do
    resource :food_truck, only: [:show], controller: 'food_trucks'
  end

# Routes for Food Trucks
resources :food_trucks do
  # Nested routes for Food Truck Ratings
  resources :food_truck_ratings, only: [:create, :edit, :update, :destroy]
end

# Checkout Routes
resources :checkout, only: [:create]


#user purchase credits routes
  get 'purchase_credits', to: 'pages#purchase_credits', as: 'purchase_credits'
  post 'checkout/create', to: 'checkout#create', as: :checkout_create
  get 'checkout/success', to: 'checkout#success', as: :checkout_success
  get 'checkout/cancel', to: 'checkout#cancel', as: :checkout_cancel

    # User Promotion Routes
  post "promote_to_event_organizer", to: "pages#promote_to_event_organizer"
  post "promote_to_food_truck_owner", to: "pages#promote_to_food_truck_owner"

  # User Profiles
  get "users/:id", to: "users#show", as: "user"
  get "profile", to: "users#show", as: "user_profile"

  # Health Check and PWA Routes
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  
  devise_scope :user do
    get 'apply_to_event/:event_id', to: 'users/registrations#apply_to_event', as: 'apply_to_event'
  end

  # Root Path
  root "pages#home"

  mount ActionCable.server => '/cable'
end
