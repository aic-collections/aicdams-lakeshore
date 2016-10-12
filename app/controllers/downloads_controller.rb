# frozen_string_literal: true
class DownloadsController < ApplicationController
  include CurationConcerns::DownloadBehavior
  include DownloadBehavior
end
