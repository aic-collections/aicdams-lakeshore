class TagsController < ApplicationController
  include TagsControllerBehavior

  class_attribute :edit_form_class, :presenter_class
  self.presenter_class = TagPresenter
  self.edit_form_class = TagEditForm

end
