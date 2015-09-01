class AssetPresenter < Sufia::GenericFilePresenter

  def self.asset_terms
    [:asset_capture_device, :digitization_source, :document_type, :legacy_uid, :comments, :tag]
  end

  def self.still_image_terms
    [:compositing, :light_type, :view]
  end

  def self.text_terms
    [:transcript]
  end

  self.terms = ResourcePresenter.terms + self.still_image_terms + self.text_terms + self.asset_terms

  def brief_terms
    [
      :relation,
      :asset_type,
      :identifier
    ]
  end

  def asset_type
    return "Image" if model.is_still_image?
    return "Text Document" if model.is_text?
  end 

end
