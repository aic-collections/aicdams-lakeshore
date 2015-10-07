Rails.application.routes.draw do
  
  blacklight_for :catalog
  devise_for :users
  Hydra::BatchEdit.add_routes(self)
  
  root to: 'homepage#index'

  # Administrative URLs
  mount Hydra::RoleManagement::Engine => '/admin'
  namespace :admin do
    # Job monitoring
    constraints ResqueAdmin do
      mount Resque::Server, at: 'queues'
    end
  end

  resources :comments
  resources :tags
  resources :tag_cats
  resources :works, except: [:new, :create, :destroy]
  resources :actors, except: [:new, :create, :destroy]
  resources :exhibitions, except: [:new, :create, :destroy]

  # Lakeshore API
  scope "api" do
    post "reindex", to: "reindex#update"
  end

  # Sufia should come last because in production it will 404 any unknown routes
  mount Sufia::Engine => '/'
  
end
