class BatchController < ApplicationController
  include Sufia::BatchControllerBehavior

  self.edit_form_class = AssetBatchEditForm
end
