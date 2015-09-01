module AssetMetadata
  extend ActiveSupport::Concern
  
  included do

    property :asset_capture_device, predicate: AIC.captureDevice, multiple: false do |index|
      index.as :stored_searchable
    end
    
    # TODO: This needs to be a ListItem
    property :digitization_source, predicate: AIC.digitizationSource, multiple: false do |index|
      index.as :stored_searchable
    end
    
    # TODO: Needs to be a DocumentType
    property :document_type, predicate: AIC.documentType, multiple: false do |index|
      index.as :stored_searchable
    end
    
    property :legacy_uid, predicate: AIC.legacyUid do |index|
      index.as :stored_searchable
    end
    
    # TODO: This needs to be a ListItem
    property :tag, predicate: AIC.tag do |index|
      index.as :stored_searchable
    end

    has_and_belongs_to_many :comments, predicate: AIC.hasComment, class_name: "Comment", inverse_of: :generic_files
    accepts_nested_attributes_for :comments, allow_destroy: true

  end

  def attributes= attributes
    ["comments_attributes"].each do |nested_attribute|
      attributes[nested_attribute].reject! { |k,v| v["content"].empty? if v && v["content"] } if attributes[nested_attribute]
    end
    super(attributes)
  end

end
