Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'
  namespace :admin do
    get '/', to: 'dashboard#index'
    resources :invoices, only: [:show, :index, :update]
    resources :merchants, only: [:index, :show, :new, :create, :edit, :update]
  end


  resources :merchants, only: [:show] do
    get '/dashboard', to: 'merchants#dashboard'
    resources :items, only: [:index, :show, :new, :create, :edit, :update]
    resources :invoices
    resources :discounts, only: [:index, :show, :new, :create, :destroy, :edit, :update]
  end
  resources :invoice_items, only: [:update]
  resources :items, only: [:create]
  

end
