# frozen_string_literal: true
module DownloadBehavior
  extend ActiveSupport::Concern

  def rights_for_file
    return :read unless thumbnail? || citi_thumbnail?
    :discover
  end

  protected

    # Supply a filename when downloading the access file
    def derivative_download_options
      if access_master?
        super.merge!(filename: access_filename)
      else
        super
      end
    end

    def authorize_download!
      return params[:id] if current_user.admin?
      authorize! rights_for_file, params[asset_param_key]
    end

    # Loads the file specified by the HTTP parameter `:file`.
    # If this object does not have a file by that name, return the default file
    # as returned by {#default_file}
    # @return [ActiveFedora::File, String, NilClass] Returns the file from the repository or a path to a file on the local file system, if it exists.
    def load_file
      file_reference = params[:file]
      return default_file unless file_reference
      return access_file if access_master?
      return citi_thumbnail if citi_thumbnail?
      return citi_large if citi_large?

      file_path = CurationConcerns::DerivativePath.derivative_path_for_reference(params[asset_param_key], file_reference)
      File.exist?(file_path) ? file_path : nil
    end

  private

    def thumbnail?
      params.fetch(:file, nil) == "thumbnail"
    end

    def access_master?
      params.fetch(:file, nil) == "accessMaster"
    end

    def citi_thumbnail?
      params.fetch(:file, nil) == "citiThumbnail"
    end

    def citi_large?
      params.fetch(:file, nil) == "citiLarge"
    end

    def access_file
      ::DerivativePath.access_path(params[asset_param_key])
    end

    def citi_thumbnail
      file = ::DerivativePath.derivative_path_for_reference(params[asset_param_key], "citi")
      return file if File.exist?(file)
    end

    def citi_large
      file = ::DerivativePath.derivative_path_for_reference(params[asset_param_key], "large")
      return file if File.exist?(file)
    end

    def access_filename
      "#{asset.parent.uid}#{File.extname(file)}"
    end
end
