class ShipmentsController < ApplicationController
  include CitiResourceBehavior

  class_attribute :edit_form_class, :presenter_class
  self.presenter_class = ShipmentPresenter
  self.edit_form_class = ShipmentEditForm
end
