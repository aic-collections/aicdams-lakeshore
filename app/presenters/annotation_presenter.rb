class AnnotationPresenter
  include Hydra::Presenter
  self.model_class = Annotation
  self.terms = [ :content, :category ]
end
