class DownloadsController < ApplicationController
  include Sufia::DownloadsControllerBehavior

  # Overrides Hydra::Controller::DownloadBehavior due to an issue with self-signed certificates, see issue #113
  # Uses Rails' ActionController::DataSteaming
  def send_file_contents
    self.status = 200
    prepare_file_headers
    send_data(file.content, filename: file_name)
  end
end
