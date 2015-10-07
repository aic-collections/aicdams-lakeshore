class ExhibitionsController < ApplicationController
  include CitiResourceBehavior

  class_attribute :edit_form_class, :presenter_class
  self.presenter_class = ExhibitionPresenter
  self.edit_form_class = ExhibitionEditForm

end
