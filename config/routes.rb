Rails.application.routes.draw do
  # Devise routes for User authentication
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

   # Routes for Events
   resources :events do
    member do
      patch :publish
    end

    # Nested routes for Event Applications with custom member actions
    resources :event_applications do
      member do
        patch :approve
        patch :reject
      end
    end
  end

  # Routes for Food Trucks
  resources :food_trucks
  resources :checkout, only: [:create]
  # User Promotion Routes
  get 'purchase_credits', to: 'pages#purchase_credits', as: 'purchase_credits'

  post "promote_to_event_organizer", to: "pages#promote_to_event_organizer"
  post "promote_to_food_truck_owner", to: "pages#promote_to_food_truck_owner"

  # User Profiles
  post 'checkout/create', to: 'checkout#create', as: :checkout_create

  # Routes for handling Stripe checkout success and cancellation
  get 'checkout/success', to: 'checkout#success', as: :checkout_success
  get 'checkout/cancel', to: 'checkout#cancel', as: :checkout_cancel

  get "users/:id", to: "users#show", as: "user"
  get "profile", to: "users#show", as: "user_profile"

  # Health Check and PWA Routes
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Root Path
  root "pages#home"
end
