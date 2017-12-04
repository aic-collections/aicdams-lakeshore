# frozen_string_literal: true
class Resource < ActiveFedora::Base
  def self.aic_type
    [AICType.Resource]
  end

  include AcceptsUris
  include BasicMetadata

  type aic_type

  property :batch_uid, predicate: AIC.batchUid, multiple: false do |index|
    index.as :stored_searchable
  end

  # TODO: Is citiIcon needed? Can it be a pcdm:File?
  property :citi_icon, predicate: AIC.citiIcon, multiple: false, class_name: "ActiveFedora::Base"

  property :contributors, predicate: ::RDF::Vocab::DC.contributor, class_name: "Agent"

  property :created, predicate: AIC.created, multiple: false do |index|
    index.type :date
    index.as :stored_sortable
  end

  property :created_by, predicate: AIC.createdBy, multiple: false, class_name: "AICUser"

  # TODO: Can we use what CC uses?
  property :icon, predicate: AIC.icon, multiple: false, class_name: "ActiveFedora::Base"

  property :updated, predicate: AIC.updated, multiple: false do |index|
    index.type :date
    index.as :stored_sortable
  end

  property :language, predicate: ::RDF::Vocab::DC11.language do |index|
    index.as :stored_searchable
  end

  property :publisher, predicate: ::RDF::Vocab::DC.publisher, class_name: "Agent"

  property :rights, predicate: ::RDF::Vocab::DC11.rights do |index|
    index.as :stored_searchable
  end

  # TODO: Needs to be aictype:Text
  property :rights_statement, predicate: ::RDF::Vocab::DC.rights, class_name: "ActiveFedora::Base"

  property :rights_holder, predicate: ::RDF::Vocab::DC.rightsHolder, class_name: "Agent"

  property :status, predicate: AIC.status, multiple: false, class_name: "ListItem"

  property :alt_label, predicate: ::RDF::Vocab::SKOS.altLabel do |index|
    index.as :stored_searchable, :symbol
  end

  accepts_uris_for :citi_icon, :contributors, :created_by, :icon, :publisher, :rights_statement, :rights_holder,
                   :status

  def active?
    status == ListItem.active_status
  end

  private

    # Returns the correct type class for attributes when loading an object from Solr
    # Catches malformed dates that will not parse into DateTime, see #198
    # @todo dead code?
    def adapt_single_attribute_value(value, attribute_name)
      AttributeValueAdapter.call(value, attribute_name) || super
    rescue ArgumentError
      "#{value} is not a valid date"
    end
end
