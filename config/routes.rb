Shoppe::Engine.routes.draw do
  
  get 'attachment/:id/:filename.:extension' => 'attachments#show'
  resources :product_categories
  resources :products do
    resources :variants
    collection do
      get :import
      post :import
    end
  end
  resources :orders do
    post :search, :on => :collection
    post :accept, :on => :member
    post :reject, :on => :member
    post :ship, :on => :member
    get :despatch_note, :on => :member
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
