class ResourcePresenter < AbstractPresenter

  def self.terms
    self.properties + self.assets
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

  def self.assets
    [:document_ids, :representation_ids, :preferred_representation_ids]
  end


end
