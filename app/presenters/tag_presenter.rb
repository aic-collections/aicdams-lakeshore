class TagPresenter
  include Hydra::Presenter
  self.model_class = Tag
  self.terms = [ :content, :tagcats ]
end
