# frozen_string_literal: true
class CollectionsController < ApplicationController
  include CurationConcerns::CollectionsControllerBehavior
  include Sufia::CollectionsControllerBehavior

  self.presenter_class = CollectionPresenter
  self.form_class = CollectionForm

  protected

    # Overrides CurationConcerns to add current_ability to the form
    def form
      @form ||= form_class.new(@collection, current_ability)
    end
end
