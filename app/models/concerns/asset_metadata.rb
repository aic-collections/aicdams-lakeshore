# frozen_string_literal: true
module AssetMetadata
  extend ActiveSupport::Concern

  included do
    property :capture_device, predicate: AIC.captureDevice, multiple: false do |index|
      index.as :stored_searchable
    end

    property :digitization_source, predicate: AIC.digitizationSource, multiple: false, class_name: "ListItem"

    property :document_type, predicate: AIC.documentType, multiple: false, class_name: "ListItem"
    property :first_document_sub_type, predicate: AIC.documentSubType1, multiple: false, class_name: "ListItem"
    property :second_document_sub_type, predicate: AIC.documentSubType2, multiple: false, class_name: "ListItem"

    property :legacy_uid, predicate: AIC.legacyUid do |index|
      index.as :stored_searchable
    end

    property :keyword, predicate: AIC.keyword, class_name: "ListItem" do |index|
      index.as :stored_searchable, :facetable, using: :pref_label
    end

    accepts_uris_for :keyword, :digitization_source, :document_type, :first_document_sub_type, :second_document_sub_type
  end
end
