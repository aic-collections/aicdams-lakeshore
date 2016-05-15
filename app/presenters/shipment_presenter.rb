# frozen_string_literal: true
class ShipmentPresenter
  include Hydra::Presenter
  include RelatedAssetTerms

  self.model_class = Shipment
  self.terms = CitiResourceTerms.all

  def summary_terms
    [:uid, :created_by, :resource_created, :resource_updated]
  end
end
