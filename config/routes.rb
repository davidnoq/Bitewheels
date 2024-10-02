Rails.application.routes.draw do
  devise_for :foodtruck_owners
  devise_for :event_organizers

  resources :events
  resources :food_truck_owners

  root to: "static#home"

  authenticated :food_truck_owner do
    root 'food_truck_owners#index', as: :authenticated_food_truck_owner_root
  end

  authenticated :event_organizer do
    root 'events#index', as: :authenticated_event_organizer_root
  end

  # Health check endpoint
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA routes
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest"
end
