class MetadataSet < Resource

  def self.aic_type
    super << AICType.MetadataSet
  end

  type aic_type

end
