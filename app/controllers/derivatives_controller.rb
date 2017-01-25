# frozen_string_literal: true
class DerivativesController < ApplicationController
  include CurationConcerns::DownloadBehavior
  include DownloadBehavior
  include DerivativeBehavior
end
