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

    collection do
      get :applications # Custom route for showing event applications
      get :events_near_me # Custom route for showing nearby events
    end

    # Nested route for Event Applications creation
    resources :event_applications, only: [ :create ]

    # Route to show a food truck in the context of an event application
    get "applications/:id/food_trucks/:food_truck_id", to: "events#show_application_food_truck", as: "show_application_food_truck"
  end

  # Routes for EventApplications with custom member actions
  resources :event_applications, only: [] do
    member do
      patch :approve
      patch :reject
    end
  end

  # Routes for Food Trucks
  resources :food_trucks

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

  # Root Path
  root "pages#home"
end
