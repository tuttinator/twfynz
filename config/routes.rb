Twfynz::Application.routes.draw do
  root :to => "application#home"
  match "search" => "application#search"
  match "about" => "application#about"

  resources :bills do
    collection do
      get "assented"
      get "negatived"
    end
  end
  resources :portfolios
  resources :mps
  resources :organisations
  resources :parliaments
  resources :debates
  resources :parties
end
