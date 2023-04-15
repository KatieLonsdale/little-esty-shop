Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :admin, only: [:index]

  namespace :admin do
    resources :merchants, only: [:index, :show]
    resources :invoices, only: [:index]
  end

  # resources :merchants, exclude: [:index, :new, :create, :edit, :update, :destroy] do
  #   resources :items, only: [:index, :show]
  #   resources :invoices, only: [:index, :show]
  # end

 get '/merchants/:id/dashboard', to: 'merchants#show'
 get '/merchants/:id/items', to: 'merchants/items#index'
 get '/merchants/:id/invoices', to: 'merchants/invoices#index'
 get '/merchants/:merchant_id/invoices/:invoice_id', to: 'merchants/invoices#show'
end