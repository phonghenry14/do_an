Rails.application.routes.draw do
  root             "static_pages#home"
  mount Commontator::Engine => '/commontator'
  mount Soulmate::Server, :at => "/autocomplete"

  get "help"    => "static_pages#help"
  get "about"   => "static_pages#about"
  get "contact" => "static_pages#contact"

  devise_for :users
  devise_scope :user do
    get "sign_out", to: "sessions#destroy"
    get "sign_in", to: "sessions#new"
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
    resources :comments do
      member do
        put "like", to: "comments#like"
        put "unlike", to: "comments#unlike"
      end
    end
  end
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
end
