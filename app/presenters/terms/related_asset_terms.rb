module RelatedAssetTerms
  delegate :documents, to: :to_model

  delegate :representations, to: :to_model

  delegate :preferred_representations, to: :to_model

  # Not all models have assets
  def assets
    []
  end

  def related_assets
    documents + representations + preferred_representations + assets
  end
end
