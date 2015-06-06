class CommentsController < ApplicationController
  include AnnotationsControllerBehavior

  class_attribute :edit_form_class, :presenter_class
  self.presenter_class = CommentPresenter
  self.edit_form_class = CommentEditForm

end
