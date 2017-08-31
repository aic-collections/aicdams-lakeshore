# frozen_string_literal: true
class CitiResource < Resource
  include CitiResourceMetadata
  include Sufia::WithEvents

  def self.aic_type
    super << AICType.CitiResource
  end

  type aic_type

  # Status defaults to active if it is nil
  def status
    super || ListItem.active_status
  end
end
