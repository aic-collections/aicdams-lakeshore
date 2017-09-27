# frozen_string_literal: true
# Used in conjunction with AclService to call the service asynchronously via ActiveJob.
class AclJob < ActiveJob::Base
  queue_as { (arguments[1] || "resolrize").to_sym }

  # @param [String] id of asset
  # @param [String] _queue name used to set the queue in ::queue_as
  def perform(id, _queue = nil)
    asset = ActiveFedora::Base.find(id)
    AclService.new(asset).update
  end
end
