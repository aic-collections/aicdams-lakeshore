Rails.application.routes.draw do
  
  blacklight_for :catalog
  devise_for :users
  Hydra::BatchEdit.add_routes(self)
  mount Sufia::Engine => '/'
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

end
