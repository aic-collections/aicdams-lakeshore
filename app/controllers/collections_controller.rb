# frozen_string_literal: true
class CollectionsController < ApplicationController
  include CurationConcerns::CollectionsControllerBehavior
  include Sufia::CollectionsControllerBehavior

  self.presenter_class = CollectionPresenter
  self.form_class = CollectionForm
end
