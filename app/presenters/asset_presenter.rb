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
    :resource_type,
    :described_by,
    :same_as,
    :pref_label
  ]
end
