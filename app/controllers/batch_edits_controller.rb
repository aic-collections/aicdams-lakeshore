# frozen_string_literal: true
class BatchEditsController < ApplicationController
  include Hydra::BatchEditBehavior
  include FileSetHelper
  include Sufia::BatchEditsControllerBehavior
  include AICAssetAfterDeleteBehavior

  def destroy_collection
    assets_with_relationships = []
    batch.each do |doc_id|
      obj = ActiveFedora::Base.find(doc_id, cast: true)
      if obj.asset_has_relationships?
        assets_with_relationships << obj.title
      else
        obj.destroy
      end
    end
    report_status_and_redirect(assets_with_relationships, batch: true)
  end

  protected

    def destroy_batch
      batch.each do |doc_id|
        gw = ::GenericWork.find(doc_id)
        report_delete_error unless gw.destroy
      end
      after_update
    end
end
