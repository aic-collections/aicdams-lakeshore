class ConservationMetadata < MetadataSet

  def self.aic_type
    super << AICType.ConservationMetadata
  end

  type aic_type

  # TODO: this needs to be singular: enforce cardinality on AT resources
  property :conservation_doc_type, predicate: AIC.conservationDocType, multiple: true, class_name: UndefinedListItem

  # TODO: this needs to be singular: enforce cardinality on AT resources
  property :special_image_type, predicate: AIC.specialImageType, multiple: true, class_name: UndefinedListItem

end
