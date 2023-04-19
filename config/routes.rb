Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :admin, only: [:index]

  namespace :admin do
    resources :merchants, only: [:index, :show, :edit, :update, :new, :create]
    resources :invoices, only: [:index, :show]
  end

  resources :merchants do
    resources :items, controller: 'merchants/items'
    resources :invoices, only: [:index, :show], controller: 'merchants/invoices'
  end

  get '/merchants/:id/dashboard', to: 'merchants#show'
  patch '/invoice_items/:id', to: 'invoice_items#update'
end