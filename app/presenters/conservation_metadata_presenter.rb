class ConservationMetadataPresenter
  include Hydra::Presenter

  def self.inherited_terms
    ResourcePresenter.terms
  end

  self.model_class = ConservationMetadataPresenter
  self.terms = [
    :conservation_doc_type,
    :special_image_type
  ] + self.inherited_terms

end
