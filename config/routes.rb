Rails.application.routes.draw do
  resources :categories, except: :show
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  
  #delete '/products/:id', to: 'products#destroy'
  #patch '/products/:id', to: 'products#update'
  #post '/products', to: 'products#create'
  #get '/products/new', to: 'products#new', as: :new_product
  #get '/products', to: 'products#index'
  #get '/products/:id', to: 'products#show', as: :product
  #get '/products/:id/edit', to: 'products#edit', as: :edit_product

  resources :products, path: '/' #hacemos que products recida en el root

  #namespace es para organizar nuestro codigo como si fueran carpetas, al especificarlo creamos en controller una carpeta authentication
  #path y as vacios para que no formen parte del url en el navegador, la ruta sería users/new

  namespace :authentication, path: '', as: '' do
    resources :users, only: [:new, :create]
    resources :sessions, only: [:new, :create]
  end


end
