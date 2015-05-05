class GenericFile < ActiveFedora::Base

  include Sufia::GenericFile
  include Validations
  
  validate :write_once_only_fields, on: :update
  after_save :uid_matches_id, on: :create

  type AICType.Resource
  
  # AIC terms

  # Same as Sufia batch id?
  property :batch_uid, predicate: AIC.batchUid, multiple: false do |index|
    index.as :stored_searchable
  end 

  property :created, predicate: AIC.created, multiple: false do |index|
    index.type :date
    index.as :stored_sortable
  end

  property :department, predicate: AIC.deptCreated, multiple: false do |index|
    index.as :stored_searchable
  end

  has_and_belongs_to_many :comments, predicate: AIC.hasComment, class_name: "Comment", inverse_of: :generic_files

  # TODO: Phase 2, this is an aictype:Location
  property :location, predicate: AIC.hasLocation do |index|
    index.as :stored_searchable
  end

  # TODO: Phase 2, this is an aictype:MetadataSet
  property :metadata, predicate: AIC.hasMetadata do |index|
    index.as :stored_searchable
  end 

  # TODO: Phase 2, this is an aictype:PublishingContext
  property :publishing_context, predicate: AIC.hasPublishingContext do |index|
    index.as :stored_searchable
  end

  has_and_belongs_to_many :tags, predicate: AIC.hasTag, class_name: "Tag", inverse_of: :generic_files

  property :legacy_uid, predicate: AIC.legacyUid do |index|
    index.as :stored_searchable
  end

  property :status, predicate: AIC.status, multiple: false do |index|
    index.as :stored_searchable
  end

  # TODO: override #new to create this once
  # Same as fedora:uuid
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

  accepts_nested_attributes_for :comments, :tags

end
