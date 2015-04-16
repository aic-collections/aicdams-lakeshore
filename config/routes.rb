Rails.application.routes.draw do
  
  blacklight_for :catalog
  devise_for :users
  Hydra::BatchEdit.add_routes(self)
  mount Sufia::Engine => '/'
  root to: 'homepage#index'

end
