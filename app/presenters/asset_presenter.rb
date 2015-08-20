class AssetPresenter < Sufia::GenericFilePresenter
  self.terms = [
    :comments,
    :location,
    :metadata,
    :publishing_context,
    :aictag_ids,
    :status,
    :contributor,
    :coverage,
    :creator,
    :date,
    :description,
    :format,
    :identifier,
    :language,
    :publisher,
    :relation,
    :rights,
    :source,
    :subject,
    :title,
    :described_by,
    :same_as,
    :pref_label
  ]

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
