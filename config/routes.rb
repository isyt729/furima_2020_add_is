Rails.application.routes.draw do
  get 'comments/new'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  devise_scope :user do
    get 'addresses', to: 'users/registrations#new_address'
    post 'addresses', to: 'users/registrations#create_address'
    get 'select_registrations', to: "users/registrations#select_registrations" 
  end

  root to: "items#index"

  resources :items do
    resources :transactions, only: [:index, :create]
    resources :comments, only: [:create]
    
    collection do
      get 'tag_search'
      get 'name_search'
    end

    member do
      get 'tag_search'
    end
  end

  resources :cards, only: [:index,:create,:destroy]
end
