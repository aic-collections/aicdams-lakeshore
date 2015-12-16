class TransactionsController < ApplicationController
  include CitiResourceBehavior

  class_attribute :edit_form_class, :presenter_class
  self.presenter_class = TransactionPresenter
  self.edit_form_class = TransactionEditForm
end
