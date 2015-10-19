class BatchController < ApplicationController
  include Sufia::BatchControllerBehavior

  self.edit_form_class = AssetBatchEditForm

  protected

    def batch_update_job
      @batch_update_job ||= LakeshoreBatchUpdateJob.new(
        current_user.user_key,
        params[:id],
        params[:title],
        edit_form_class.model_attributes(params[:generic_file]),
        params[:visibility])
    end

end
