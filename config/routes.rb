SimpleBankingApp::Application.routes.draw do

  get "transfers/create"

  get "users/show"

  resources :sessions, only: [:new, :create, :destroy]

  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete

  resources :users, only: [:show]
  resources :transfers, only: [:create, :index]

  root :to =>  "users#show" 

end
