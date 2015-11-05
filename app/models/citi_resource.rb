class CitiResource < Resource
  
  def self.aic_type
    super << AICType.CitiResource
  end

  type aic_type

  property :citi_uid, predicate: AIC.citiUid do |index|
    index.as :stored_searchable
  end

  # TODO: Placeholder value until CITI resources are imported using the correct Fedora
  # resource that denotes an active status. See #127
  def status
    StatusType.active
  end

end
