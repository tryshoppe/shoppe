Shoppe::Engine.routes.draw do

  get 'attachment/:id/:filename.:extension' => 'attachments#show'
  resources :product_categories
  resources :product_templates do
    collection do
      get :dialog
      get :template_attributes
    end
  end
  resources :products do
    resources :variants
    collection do
      get :import
      post :import
    end
  end
  resources :orders do
    collection do
      post :search
    end
    member do
      post :accept
      post :reject
      post :ship
      get :despatch_note
    end
    resources :payments, :only => [:create, :destroy] do
      match :refund, :on => :member, :via => [:get, :post]
    end
  end
  resources :stock_level_adjustments, :only => [:index, :create]
  resources :delivery_services do
    resources :delivery_service_prices
  end
  resources :tax_rates
  resources :users
  resources :countries
  resources :attachments, :only => :destroy

  get 'settings'=> 'settings#edit'
  post 'settings' => 'settings#update'

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  match 'login/reset' => 'sessions#reset', :via => [:get, :post]

  delete 'logout' => 'sessions#destroy'
  root :to => 'dashboard#home'
end
