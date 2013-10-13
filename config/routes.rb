Twfynz::Application.routes.draw do
  root :to => "application#home"
  match "search" => "application#search"
  match "about" => "application#about"

  resources :bills
  resources :portfolios
  resources :mps
  resources :organisations
  resources :parliaments
  resources :debates
  resources :parties
end
