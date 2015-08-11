class WorkPresenter
  include Hydra::Presenter

  # These are terms inherited from parent classes, excepting the nested terms from NestedMetadata
  # which are applied the Assets (i.e. GenericFiles)
  def self.inherited_terms
    AssetPresenter.terms - [:comments, :aictag_ids, :location, :metadata, :publishing_context]
  end

  self.model_class = Work
  self.terms = [
    :after,
    :artist_display,
    :artist_uid,
    :before,
    :coll_cat_uid,
    :credit_line,
    :dept_uid,
    :dimensions_display,
    :exhibition_history,
    :gallery_location,
    :inscriptions,
    :main_ref_number,
    :medium_display,
    :object_type,
    :place_of_origin,
    :provenance_text,
    :publication_history,
    :publ_tag,
    :publ_ver_level
  ] + self.inherited_terms

end
