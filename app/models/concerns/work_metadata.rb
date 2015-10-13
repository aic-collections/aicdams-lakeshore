module WorkMetadata
  extend ActiveSupport::Concern
  
  included do

    property :artist_uid, predicate: AIC.artistUid do |index|
      index.as :stored_searchable
    end

    property :citi_uid, predicate: AIC.citiUid, multiple: false do |index|
      index.as :stored_searchable
    end

    property :creator_display, predicate: AIC.creatorDisplay, multiple: false do |index|
      index.as :stored_searchable
    end

    property :credit_line, predicate: AIC.creditLine, multiple: false do |index|
      index.as :stored_searchable
    end

    property :date_display, predicate: AIC.dateDisplay, multiple: false do |index|
      index.as :stored_searchable
    end

    property :department, predicate: AIC.deptUid, multiple: true do |index|
      index.type :integer
      index.as :stored_searchable
    end

    property :dimensions_display, predicate: AIC.dimensionsDisplay do |index|
      index.as :stored_searchable
    end

    property :earliest_date, predicate: AIC.earliestDate, multiple: false do |index|
      index.type :date
      index.as :stored_searchable
    end

    property :earliest_year, predicate: AIC.earliestYear, multiple: false do |index|
      index.as :stored_searchable
    end

    property :exhibition_history, predicate: AIC.exhibitionHistory, multiple: false do |index|
      index.as :stored_searchable
    end

    property :gallery_location, predicate: AIC.galleryLocation, multiple: false do |index|
      index.as :stored_searchable
    end

    has_and_belongs_to_many :assets, predicate: AIC.hasConstituent, class_name: "GenericFile"
    accepts_nested_attributes_for :assets, allow_destroy: false

    property :inscriptions, predicate: AIC.inscriptions, multiple: false do |index|
      index.as :stored_searchable
    end

    property :latest_date, predicate: AIC.latestDate, multiple: false do |index|
      index.type :date
      index.as :stored_searchable
    end

    property :latest_year, predicate: AIC.latestYear, multiple: false do |index|
      index.as :stored_searchable
    end

    property :main_ref_number, predicate: AIC.mainRefNumber, multiple: false do |index|
      index.as :stored_searchable
    end

    property :medium_display, predicate: AIC.mediumDisplay, multiple: false do |index|
      index.as :stored_searchable
    end

    property :object_type, predicate: AIC.objectType, multiple: false do |index|
      index.as :stored_searchable
    end

    property :place_of_origin_uid, predicate: AIC.placeOfOriginUid, multiple: false do |index|
      index.as :stored_searchable
    end

    property :provenance_text, predicate: AIC.provenanceText, multiple: false do |index|
      index.as :stored_searchable
    end

    property :publ_ver_level, predicate: AIC.publVerLevel, multiple: false do |index|
      index.as :stored_searchable
    end

    property :publication_history, predicate: AIC.publicationHistory, multiple: false do |index|
      index.as :stored_searchable
    end
  
  end

end
