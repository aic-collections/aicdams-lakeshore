class TagsController < ApplicationController
  include AnnotationsControllerBehavior

  class_attribute :edit_form_class, :presenter_class
  self.presenter_class = TagPresenter
  self.edit_form_class = TagEditForm

end
