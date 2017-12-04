# frozen_string_literal: true
module AssetMetadata
  extend ActiveSupport::Concern
  extend Deprecation

  included do
    property :capture_device, predicate: AIC.captureDevice, multiple: false do |index|
      index.as :stored_searchable
    end

    property :digitization_source, predicate: AIC.digitizationSource, multiple: false, class_name: "ListItem"

    property :document_type, predicate: AIC.documentType, multiple: false, class_name: "Definition"
    property :first_document_sub_type, predicate: AIC.documentSubType1, multiple: false, class_name: "Definition"
    property :second_document_sub_type, predicate: AIC.documentSubType2, multiple: false, class_name: "Definition"

    # Force these to singular terms. Ensure a nil or empty set forces a change.
    def document_type=(value)
      document_type_will_change! unless value.present?
      if value.respond_to?(:each)
        super(value.first)
      else
        super(value)
      end
    end

    def first_document_sub_type=(value)
      first_document_sub_type_will_change! unless value.present?
      if value.respond_to?(:each)
        super(value.first)
      else
        super(value)
      end
    end

    def second_document_sub_type=(value)
      second_document_sub_type_will_change! unless value.present?
      if value.respond_to?(:each)
        super(value.first)
      else
        super(value)
      end
    end

    property :legacy_uid, predicate: AIC.legacyUid do |index|
      index.as :stored_searchable
    end

    property :keyword, predicate: AIC.keyword, class_name: "ListItem" do |index|
      index.as :stored_searchable, :facetable, using: :pref_label
    end

    property :external_resources, predicate: AIC.hasExternalContent do |index|
      index.as :stored_searchable
    end

    property :publish_channels, predicate: AIC.publishChannel, class_name: "PublishChannel"

    property :attachment_of, predicate: AIC.isAttachmentOf, class_name: "GenericWork"
    alias_method :attachments, :attachment_of
    deprecation_deprecate :attachments

    property :document_of, predicate: AIC.isDocumentOf, class_name: "CitiResource"

    property :preferred_representation_of, predicate: AIC.isPreferredRepresentationOf, class_name: "CitiResource"

    property :representation_of, predicate: AIC.isRepresentationOf, class_name: "CitiResource"

    property :copyright_representatives, predicate: AIC.copyrightRepresentative, class_name: "Agent" do |index|
      index.as :stored_searchable, using: :pref_label
    end

    property :licensing_restrictions, predicate: AIC.licensingRestriction, class_name: "ListItem" do |index|
      index.as :stored_searchable, using: :pref_label
    end

    property :public_domain, predicate: AIC.publicDomain, multiple: false

    property :publishable, predicate: AIC.isPublishable, multiple: false

    property :caption, predicate: AIC.nonObjCaption, multiple: false do |index|
      index.as :stored_searchable
    end

    accepts_uris_for :keyword, :digitization_source, :document_type, :first_document_sub_type,
                     :second_document_sub_type, :publish_channels, :attachment_of, :copyright_representatives,
                     :licensing_restrictions, :document_of, :preferred_representation_of, :representation_of
  end
end
