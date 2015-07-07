module WorkMetadata
  extend ActiveSupport::Concern
  
  included do
    
    property :after, predicate: AIC.after, multiple: true do |index|
      index.type :date
      index.as :stored_sortable
    end
    
    property :artist_display, predicate: AIC.artistDisplay, multiple: true do |index|
      index.as :stored_searchable
    end
    
    property :artist_uid, predicate: AIC.artistUid, multiple: true do |index|
      index.as :stored_searchable
    end
    
    property :before, predicate: AIC.before, multiple: true do |index|
      index.type :date
      index.as :stored_sortable
    end
    
    property :coll_cat_uid, predicate: AIC.collCatUid, multiple: true do |index|
      index.as :stored_searchable
    end
    
    property :credit_line, predicate: AIC.creditLine, multiple: true do |index|
      index.as :stored_searchable
    end
    
    property :dept_uid, predicate: AIC.deptUid, multiple: true do |index|
      index.as :stored_searchable
    end
    
    property :dimensions_display, predicate: AIC.dimensionsDisplay, multiple: true do |index|
      index.as :stored_searchable
    end
    
    property :exhibition_history, predicate: AIC.exhibitionHistory, multiple: true do |index|
      index.as :stored_searchable
    end
    
    property :gallery_location, predicate: AIC.galleryLocation, multiple: true do |index|
      index.as :stored_searchable
    end
    
    property :inscriptions, predicate: AIC.inscriptions, multiple: true do |index|
      index.as :stored_searchable
    end
    
    property :main_ref_number, predicate: AIC.mainRefNumber, multiple: true do |index|
      index.as :stored_searchable
    end
    
    property :medium_display, predicate: AIC.mediumDisplay, multiple: true do |index|
      index.as :stored_searchable
    end
    
    property :object_type, predicate: AIC.objectType, multiple: true do |index|
      index.as :stored_searchable
    end
    
    property :place_of_origin, predicate: AIC.placeOfOrigin, multiple: true do |index|
      index.as :stored_searchable
    end
    
    property :provenance_text, predicate: AIC.provenanceText, multiple: true do |index|
      index.as :stored_searchable
    end
    
    property :publication_history, predicate: AIC.publicationHistory, multiple: true do |index|
      index.as :stored_searchable
    end
    
    property :publ_tag, predicate: AIC.publTag, multiple: true do |index|
      index.as :stored_searchable
    end
    
    property :publ_ver_level, predicate: AIC.publVerLevel, multiple: false do |index|
      index.as :stored_searchable
    end
  
  end

end
