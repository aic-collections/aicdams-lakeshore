module AssetMetadata
  extend ActiveSupport::Concern

  included do
    property :asset_capture_device, predicate: AIC.captureDevice, multiple: false do |index|
      index.as :stored_searchable
    end

    property :digitization_source, predicate: AIC.digitizationSource, multiple: false, class_name: "ListItem"

    def digitization_source_id=(id)
      if id.nil? || id.blank?
        self.digitization_source = nil
      else
        self.digitization_source = ListItem.find(id)
      end
    end

    property :document_type, predicate: AIC.documentType, multiple: true, class_name: "ListItem"

    def document_type_ids=(ids)
      return if ids.nil?
      self.document_type = ids.map { |id| ListItem.find(id) }
    end

    property :legacy_uid, predicate: AIC.legacyUid do |index|
      index.as :stored_searchable
    end

    property :tag, predicate: AIC.tag, multiple: true, class_name: "ListItem"

    def tag_ids=(ids)
      return if ids.nil?
      self.tag = ids.map { |id| ListItem.find(id) }
    end

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

  private

    # Returns the correct type class for status when loading an object from Solr
    def adapt_single_attribute_value(value, attribute_name)
      if ["digitization_source", "document_type", "tag"].include?(attribute_name)
        return unless value.present?
        id = value.fetch("id", nil)
        return if id.nil?
        ListItem.find(id)
      else
        super
      end
    end
end
