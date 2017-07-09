# frozen_string_literal: true
class UpdateIndexJob < ActiveJob::Base
  queue_as { (arguments[1] || "resolrize").to_sym }

  # @param [String] id of resource to reindex
  # @param [String] _queue name used to set the queue in ::queue_as
  def perform(id, _queue = nil)
    return unless ActiveFedora::Base.exists?(id)
    ActiveFedora::SolrService.add(ActiveFedora::Base.find(id).to_solr, softCommit: false)
  end
end
