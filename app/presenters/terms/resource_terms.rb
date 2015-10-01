class ResourceTerms

  def self.all
    self.properties + self.related_asset_ids
  end

  def self.properties
    [
      :batch_uid,
      :contributor,
      :resource_created,
      :created_by,
      :dept_created,
      :described_by,
      :description,
      :resource_label,
      :language,
      :legacy_uid,
      :pref_label,
      :publisher,
      :rights,
      :rights_holder,
      :same_as,
      :status,
      :uid,
      :resource_updated,
    ]
  end

  def self.related_asset_ids
    [:document_ids, :representation_ids, :preferred_representation_ids]
  end

  def self.related_assets
    [:documents, :representations, :preferred_representations]
  end

end
