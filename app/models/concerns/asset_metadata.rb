module AssetMetadata
  extend ActiveSupport::Concern

  included do
    property :asset_capture_device, predicate: AIC.captureDevice, multiple: false do |index|
      index.as :stored_searchable
    end

    # TODO: this needs to be singular: enforce cardinality on AT resources
    property :digitization_source, predicate: AIC.digitizationSource, multiple: true, class_name: UndefinedListItem

    # TODO: this needs to be singular: enforce cardinality on AT resources
    property :document_type, predicate: AIC.documentType, multiple: true, class_name: UndefinedListItem

    property :legacy_uid, predicate: AIC.legacyUid do |index|
      index.as :stored_searchable
    end

    property :tag, predicate: AIC.tag, multiple: true, class_name: UndefinedListItem

    has_and_belongs_to_many :comments, predicate: AIC.hasComment, class_name: "Comment", inverse_of: :generic_files
    accepts_nested_attributes_for :comments, allow_destroy: true

    has_many :works, inverse_of: :assets, class_name: "Work"
  end

  def attributes=(attributes)
    ["comments_attributes"].each do |nested_attribute|
      attributes[nested_attribute].reject! { |_k, v| v["content"].empty? if v && v["content"] } if attributes[nested_attribute]
    end
    super(attributes)
  end
end
