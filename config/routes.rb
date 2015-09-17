Rails.application.routes.draw do
  root             "static_pages#home"

  get "help"    => "static_pages#help"
  get "about"   => "static_pages#about"
  get "contact" => "static_pages#contact"

  devise_for :users
  devise_scope :user do
    get "sign_out", to: "devise/sessions#destroy"
    get "sign_in", to: "devise/sessions#new"
    get "sign_up", to: "devise/registrations#new"
  end
  resources :users
  resources :statuses, only: [:create, :destroy]
end
