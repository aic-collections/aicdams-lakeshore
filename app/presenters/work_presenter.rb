class WorkPresenter
  include Hydra::Presenter

  # These are terms inherited from parent classes, excepting the nested terms from NestedMetadata
  # which are applied the Assets (i.e. GenericFiles)
  def self.inherited_terms
    CitiResourcePresenter.terms
  end

  self.model_class = Work
  self.terms = [
    :artist_uid,
    :citi_uid,
    :creator_display,
    :credit_line,
    :date_display,
    :department,
    :dimensions_display,
    :earliest_date,
    :earliest_year,
    :exhibition_history,
    :gallery_location,
    :assets,
    :inscriptions,
    :latest_date,
    :latest_year,
    :main_ref_number,
    :medium_display,
    :object_type,
    :place_of_origin_uid,
    :provenance_text,
    :publ_ver_level,
    :publication_history,
  ] + self.inherited_terms

end
