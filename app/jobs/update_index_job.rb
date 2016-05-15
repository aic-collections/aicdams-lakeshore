# frozen_string_literal: true
class UpdateIndexJob < ActiveJob::Base
  queue_as :resolrize

  def perform(id)
    return unless ActiveFedora::Base.exists?(id)
    ActiveFedora::Base.find(id).update_index
  end
end
