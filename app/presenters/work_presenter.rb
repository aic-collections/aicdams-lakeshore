class WorkPresenter
  include Hydra::Presenter
  self.model_class = Work
  self.terms = [ 
    :assets,
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
  ]

end
