# frozen_string_literal: true
class CurationConcerns::GenericWorksController < ApplicationController
  include CurationConcerns::CurationConcernController
  include Sufia::WorksControllerBehavior
  include CitiResourceBehavior
  include AICAssetAfterDeleteBehavior
  self.curation_concern_type = GenericWork
  self.show_presenter = AssetPresenter

  def destroy
    asset_with_relationships = []
    if curation_concern.asset_has_relationships?
      asset_with_relationships << curation_concern.to_s
    else
      curation_concern.destroy
    end
    report_status_and_redirect(asset_with_relationships, batch: false)
  end

  protected

    def search_builder_class
      AssetSearchBuilder
    end
end
