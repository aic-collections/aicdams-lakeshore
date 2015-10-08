class ShipmentPresenter
  include Hydra::Presenter
  include RelatedAssetTerms

  self.model_class = Shipment
  self.terms = CitiResourceTerms.all

end
