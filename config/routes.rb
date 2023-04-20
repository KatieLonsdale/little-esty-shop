Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :admin, only: [:index]

  namespace :admin do
    resources :merchants, only: [:index, :show, :edit, :update, :new, :create]
    resources :invoices, only: [:index, :show]
  end
  
 get '/merchants/:merchant_id/items/new', to: 'merchants/items#new'
 post '/merchants/:merchant_id/items', to: 'merchants/items#create'
 get '/merchants/:merchant_id/items/:item_id', to: 'merchants/items#show'
 get '/merchants/:merchant_id/items/:item_id/edit', to: 'merchants/items#edit'
 patch '/merchants/:merchant_id/items/:item_id', to: 'merchants/items#update'
 get '/merchants/:id/dashboard', to: 'merchants#show'
 get '/merchants/:id/items', to: 'merchants/items#index'
 get '/merchants/:id/invoices', to: 'merchants/invoices#index'
 get '/merchants/:merchant_id/invoices/:invoice_id', to: 'merchants/invoices#show'
 patch '/invoice_items/:id', to: 'invoice_items#update'
end