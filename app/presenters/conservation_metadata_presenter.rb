class ConservationMetadataPresenter
  include Hydra::Presenter

  self.model_class = ConservationMetadataPresenter
  self.terms = [
    :conservation_doc_type,
    :special_image_type
  ] + ResourceTerms.all

end
