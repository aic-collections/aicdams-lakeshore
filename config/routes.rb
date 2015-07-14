Rails.application.routes.draw do
  
  blacklight_for :catalog
  devise_for :users
  Hydra::BatchEdit.add_routes(self)
  
  root to: 'homepage#index'

  # Administrative URLs
  namespace :admin do
    # Job monitoring
    constraints ResqueAdmin do
      mount Resque::Server, at: 'queues'
    end
  end

  resources :comments
  resources :tags
  resources :tag_cats
  resources :works

  # Sufia should come last because in production it will 404 any unknown routes
  mount Sufia::Engine => '/'
  
end
