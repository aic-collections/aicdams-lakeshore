class CitiResource < Resource
  
  def self.aic_type
    super << AICType.CitiResource
  end

  type aic_type

  property :citi_uid, predicate: AIC.citiUid do |index|
    index.as :stored_searchable
  end 

end
