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
  resources :mps do
    collection do
      get "by_first"
      get "by_party"
      get "by_electorate"
      get "contribution_match"
    end
  end
  resources :organisations
  resources :parliaments
  resources :debates
  resources :parties
  resources :written_questions do
    collection do
      get "by_asker"
      get "by_portfolio"
    end
  end
end
