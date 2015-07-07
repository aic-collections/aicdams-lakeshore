class WorksController < ApplicationController
  include WorksControllerBehavior

  class_attribute :edit_form_class, :presenter_class
  self.presenter_class = WorkPresenter
  self.edit_form_class = WorkEditForm

end
