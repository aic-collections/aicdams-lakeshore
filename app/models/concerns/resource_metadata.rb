module ResourceMetadata
  extend ActiveSupport::Concern

  included do
    property :batch_uid, predicate: AIC.batchUid, multiple: false do |index|
      index.as :stored_searchable
    end

    property :contributor, predicate: AIC.contributor do |index|
      index.as :stored_searchable
    end

    property :resource_created, predicate: AIC.created, multiple: false do |index|
      index.type :date
      index.as :stored_sortable
    end

    property :created_by, predicate: AIC.createdBy do |index|
      index.as :stored_searchable
    end

    property :legacy_uid, predicate: AIC.legacyUid do |index|
      index.as :stored_searchable
    end

    property :uid, predicate: AIC.uid, multiple: false do |index|
      index.as :symbol
    end

    property :resource_updated, predicate: AIC.updated, multiple: false do |index|
      index.type :date
      index.as :stored_sortable
    end

    property :description, predicate: ::RDF::DC.description do |index|
      index.as :stored_searchable
    end

    property :language, predicate: ::RDF::DC.language do |index|
      index.as :stored_searchable
    end

    property :publisher, predicate: ::RDF::DC.publisher do |index|
      index.as :stored_searchable
    end

    property :rights, predicate: ::RDF::DC.rights do |index|
      index.as :stored_searchable
    end

    property :rights_holder, predicate: ::RDF::DC.rightsHolder do |index|
      index.as :stored_searchable
    end

    property :same_as, predicate: ::RDF::OWL.sameAs do |index|
      index.as :stored_searchable
    end

    property :pref_label, predicate: ::RDF::SKOS.prefLabel, multiple: false do |index|
      index.as :stored_searchable
    end

    property :resource_label, predicate: ::RDF::RDFS.label do |index|
      index.as :stored_searchable
    end

    property :icon, predicate: AIC.icon, multiple: false do |index|
      index.as :stored_searchable
    end

    property :dept_created, predicate: AIC.deptCreated, multiple: false, class_name: "Department"

    # TODO: Using ::RDF::Vocab::IANA.describedby causes Ldp::Conflict
    has_and_belongs_to_many :described_by, predicate: ::RDF::URI("http://need.another.predicate/here"), class_name: "MetadataSet"

    has_and_belongs_to_many :documents, predicate: AIC.hasDocument, class_name: "GenericFile"
    has_and_belongs_to_many :preferred_representations, predicate: AIC.hasPreferredRepresentation, class_name: "GenericFile"
    has_and_belongs_to_many :representations, predicate: AIC.hasRepresentation, class_name: "GenericFile"

    accepts_nested_attributes_for :described_by, :documents, :preferred_representations, :representations, allow_destroy: false
  end
end
