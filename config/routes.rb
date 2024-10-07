Rails.application.routes.draw do
devise_for :users, controllers: {
  registrations: "users/registrations"
}
resources :events

root "pages#home"
  
post 'promote_to_event_organizer', to: 'pages#promote_to_event_organizer'

get "users/show"
get 'profile', to: 'users#show', as: 'user_profile'
get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
