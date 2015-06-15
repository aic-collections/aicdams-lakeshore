module AssetMetadata
  extend ActiveSupport::Concern
  
  included do

    # Same as Sufia batch id?
    property :batch_uid, predicate: AIC.batchUid, multiple: false do |index|
      index.as :stored_searchable
    end 

    property :aiccreated, predicate: AIC.created, multiple: false do |index|
      index.type :date
      index.as :stored_sortable
    end

    property :department, predicate: AIC.deptCreated, multiple: false do |index|
      index.as :stored_searchable
    end

    property :legacy_uid, predicate: AIC.legacyUid do |index|
      index.as :stored_searchable
    end

    property :status, predicate: AIC.status, multiple: false do |index|
      index.as :stored_searchable
    end

    property :uid, predicate: AIC.uid, multiple: false

    property :updated, predicate: AIC.updated, multiple: false do |index|
      index.type :date
      index.as :stored_sortable
    end

    # Additional DC terms not in Sufia::GenericFile::Metadata

    property :coverage, predicate: ::RDF::DC.coverage do |index|
      index.as :stored_searchable
    end
    property :date, predicate: ::RDF::DC.date do |index|
      index.as :stored_searchable
    end
    property :format, predicate: ::RDF::DC.format do |index|
      index.as :stored_searchable
    end
    property :relation, predicate: ::RDF::DC.relation do |index|
      index.as :stored_searchable
    end
    property :resource_type, predicate: ::RDF::DC.type do |index|
      index.as :stored_searchable
    end

    # Addtional terms in other schema

    property :described_by, predicate: ::RDF::Vocab::IANA.describedby do |index|
      index.as :stored_searchable
    end
    property :same_as, predicate: ::RDF::OWL.sameAs do |index|
      index.as :stored_searchable
    end
    property :pref_label, predicate: ::RDF::SKOS.prefLabel, multiple: false do |index|
      index.as :stored_searchable
    end

  end

end
