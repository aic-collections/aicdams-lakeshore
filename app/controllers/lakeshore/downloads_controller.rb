# frozen_string_literal: true
module Lakeshore
  class DownloadsController < APIController
    include CurationConcerns::DownloadBehavior
    include DownloadBehavior

    protected

      # Overrides CurationConcerns::DownloadBehavior to return 404 instead of 302
      def authorize_download!
        return head :unauthorized unless ActiveFedora::Base.exists?(params[asset_param_key])
        return params[:id] if evaluated_as_admin? || proxy_ability.can?(:read, params[asset_param_key])
        head :unauthorized
      end

    private

      # Only check admin access for the api user if no proxy user is specified
      def evaluated_as_admin?
        return false if params.key?(:on_behalf_of)
        current_user.admin?
      end

      def proxy_ability
        Ability.new(User.find_by_email(params.fetch(:on_behalf_of, nil)))
      end
  end
end
