class CommentPresenter
  include Hydra::Presenter
  self.model_class = Comment
  self.terms = [:content, :category]
end
