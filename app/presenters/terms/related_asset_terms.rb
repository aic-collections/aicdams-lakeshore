module RelatedAssetTerms

  def documents
    self.to_model.documents
  end

  def representations
    self.to_model.representations
  end

  def preferred_representations
    self.to_model.preferred_representations
  end

  # Not all models have assets
  def assets
    []
  end

  def related_assets
    documents + representations + preferred_representations + assets
  end

end
