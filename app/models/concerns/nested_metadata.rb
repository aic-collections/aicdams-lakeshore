module NestedMetadata
  extend ActiveSupport::Concern
  
  included do
  
    has_and_belongs_to_many :comments, predicate: AIC.hasComment, class_name: "Comment", inverse_of: :generic_files
    has_and_belongs_to_many :tags, predicate: AIC.hasTag, class_name: "Tag", inverse_of: :generic_files

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

    accepts_nested_attributes_for :comments, :tags

  end
end
