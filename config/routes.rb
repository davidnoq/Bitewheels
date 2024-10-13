Rails.application.routes.draw do
  resources :food_trucks, only: [:index, :show, :edit, :update, :destroy]

devise_for :users, controllers: {
  registrations: "users/registrations"
}
resources :events do
  member do
    patch :publish
  end
  resources :food_trucks, only: [:new, :create]
end



root "pages#home"
get "shared/navbar"  
post 'promote_to_event_organizer', to: 'pages#promote_to_event_organizer'
post 'promote_to_food_truck_owner', to: 'pages#promote_to_food_truck_owner'
get 'users/:id', to: 'users#show', as: 'user'

get 'profile', to: 'users#show', as: 'user_profile'
get "up" => "rails/health#show", as: :rails_health_check

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
