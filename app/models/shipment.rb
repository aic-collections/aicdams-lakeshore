# frozen_string_literal: true
class Shipment < CitiResource
  include ::CurationConcerns::WorkBehavior
  include CitiBehaviors

  def self.aic_type
    super << AICType.Shipment
  end

  type type + aic_type
end
