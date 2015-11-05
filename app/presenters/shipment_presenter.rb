class ShipmentPresenter
  include Hydra::Presenter
  include RelatedAssetTerms
  include CitiStatus

  self.model_class = Shipment
  self.terms = CitiResourceTerms.all

end
