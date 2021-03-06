Rails.application.routes.draw do
  root             "static_pages#home"
  mount Commontator::Engine => '/commontator'
  mount Soulmate::Server, :at => "/autocomplete"

  get "help"    => "static_pages#help"
  get "about"   => "static_pages#about"
  get "contact" => "static_pages#contact"

  devise_for :users
  devise_scope :user do
    get "sign_out", to: "devise/sessions#destroy"
    get "sign_in", to: "devise/sessions#new"
    get "sign_up", to: "devise/registrations#new"
  end
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :statuses do
    member do
      put "like", to: "statuses#like"
      put "unlike", to: "statuses#unlike"
    end
  end

  resources :tasks do
    member do
      put "like", to: "tasks#like"
      put "unlike", to: "tasks#unlike"
    end
  end

  resources :comments
  resources :activities

  resources :relationships, only: [:create, :destroy] do
    member do
        put "follow", to: "relationships#follow"
        put "unfollow", to: "relationships#unfollow"
    end
  end

  resources :conversations do
    resources :messages
  end

  resources :groups do
    resource :user_groups
    get "add_members" => "user_groups#show"
  end

  resources :events do
    resource :user_events
    get "add_members" => "user_events#show"
  end
end
