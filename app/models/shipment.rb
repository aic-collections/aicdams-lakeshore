class Shipment < CitiResource
  include CitiBehaviors

  def self.aic_type
    super << AICType.Shipment
  end

  type aic_type

end
