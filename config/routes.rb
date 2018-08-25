Rails.application.routes.draw do
  get 'static_pages/home'
  get 'sessions/new'
  post 'sessions/create'
  delete 'sessions/destroy'
  resources :users
  resources :microposts, only: [:create, :destroy]
end
