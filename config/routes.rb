Rails.application.routes.draw do
  get 'static_pages/home'
  get 'sessions/new'
  post 'sessions/create'
  delete 'sessions/destroy'
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :microposts, only: [:create, :destroy] do
    member do
      post :create_reply
    end
  end
  resources :relationships, only: [:create, :destroy]
end
