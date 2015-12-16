class CommentsController < ApplicationController
  include CommentsControllerBehavior

  class_attribute :edit_form_class, :presenter_class
  self.presenter_class = CommentPresenter
  self.edit_form_class = CommentEditForm
end
