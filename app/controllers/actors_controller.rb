class ActorsController < ApplicationController
  include CitiResourceBehavior

  class_attribute :edit_form_class, :presenter_class
  self.presenter_class = ActorPresenter
  self.edit_form_class = ActorEditForm

end
