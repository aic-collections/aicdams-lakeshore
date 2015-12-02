class BatchEditsController < ApplicationController
  include Hydra::BatchEditBehavior
  include GenericFileHelper
  include Sufia::BatchEditsControllerBehavior

  def destroy_collection
      batch.each do |doc_id|
        obj = ActiveFedora::Base.find(doc_id, :cast=>true)
        report_delete_error unless obj.destroy
      end
      flash[:notice] = "Batch delete complete" if flash[:error].nil?
      after_destroy_collection    
  end 

  protected

    def destroy_batch
      batch.each do |doc_id|
        gf = ::GenericFile.find(doc_id)
        report_delete_error unless gf.destroy
      end
      after_update
    end

  private

    def report_delete_error
      flash[:error] = "Some assets were not deleted because they have resources linking to them"
    end
end