module AssetMetadata
  extend ActiveSupport::Concern

  included do
    property :asset_capture_device, predicate: AIC.captureDevice, multiple: false do |index|
      index.as :stored_searchable
    end

    property :digitization_source, predicate: AIC.digitizationSource, multiple: false, class_name: "ListItem"

    def digitization_source_id=(id)
      self.digitization_source = (id.nil? || id.blank?) ? nil : ListItem.find(id)
    end

    property :document_type, predicate: AIC.documentType, multiple: true, class_name: "ListItem"

    # TODO: See issue #178
    def document_type_ids=(ids)
      return if ids.nil?
      ids.reject!(&:empty?)
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

  # Adds the asset as a representation to the resource
  # @param [String] resource_id that will have the asset as a representation
  def representation_for=(resource_id)
    resource = ActiveFedora::Base.find(resource_id)
    resource.representation_ids += [id]
    resource.save
  rescue ActiveFedora::ObjectNotFoundError
    nil
  end

  # Adds the asset as a document to the resource
  # @param [String] resource_id that will have the asset as a document
  def document_for=(resource_id)
    resource = ActiveFedora::Base.find(resource_id)
    resource.document_ids += [id]
    resource.save
  rescue ActiveFedora::ObjectNotFoundError
    nil
  end

  private

    # Returns the correct type class for status when loading an object from Solr
    # TODO: Should be refactored into a service to fix complexity issues, see #216
    # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    def adapt_single_attribute_value(value, attribute_name)
      if ["digitization_source", "document_type", "tag"].include?(attribute_name)
        return unless value.present?
        id = value.fetch("id", nil)
        return if id.nil?
        ListItem.find(id)
      elsif attribute_name == "aic_depositor"
        return unless value.present?
        id = value.fetch("id", nil)
        return if id.nil?
        AICUser.find(id)
      elsif attribute_name == "dept_created"
        return unless value.present?
        id = value.fetch("id", nil)
        return if id.nil?
        Department.find(id)
      else
        super
      end
    end
  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
end
