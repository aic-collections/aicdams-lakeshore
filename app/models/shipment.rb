class Shipment < CitiResource

  def self.aic_type
    super << AICType.Shipment
  end

  type aic_type

end
