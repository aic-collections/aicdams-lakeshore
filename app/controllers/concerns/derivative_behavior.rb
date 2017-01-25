# frozen_string_literal: true
module DerivativeBehavior
  extend ActiveSupport::Concern

  included do
    before_action :validate_file_set, :validate_file, only: [:show]
  end

  def validate_file_set
    return unless asset.intermediate_file_set.empty?
    render_404
  end

  def validate_file
    return if params[:file] == "access_master"
    render_404
  end

  protected

    def load_file
      file_set = asset.intermediate_file_set.first
      ::DerivativePath.access_path(file_set.id)
    end
end
