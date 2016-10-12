# frozen_string_literal: true
module Lakeshore
  class DownloadsController < APIController
    include CurationConcerns::DownloadBehavior
    include DownloadBehavior

    protected

      # Overrides CurationConcerns::DownloadBehavior to return 404 instead of 302
      def authorize_download!
        return head :unauthorized unless ActiveFedora::Base.exists?(params[asset_param_key])
        return params[:id] if current_user.admin? || current_ability.can?(:read, params[asset_param_key])
        head :unauthorized
      end
  end
end
