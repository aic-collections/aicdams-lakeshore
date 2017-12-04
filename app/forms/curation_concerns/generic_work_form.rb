# frozen_string_literal: true
module CurationConcerns
  class GenericWorkForm < Sufia::Forms::WorkForm
    include AssetFormBehaviors
    include PropertyPermissions

    delegate :dept_created, :copyright_representatives, to: :model

    def self.aic_terms
      [
        :asset_type, :document_type_uri, :first_document_sub_type_uri, :second_document_sub_type_uri,
        :pref_label, :alt_label, :description, :language, :publisher, :capture_device,
        :status_uri, :digitization_source_uri, :compositing_uri, :light_type_uri, :view_uris,
        :keyword_uris, :publish_channel_uris, :view_notes, :visual_surrogate, :external_resources,
        :copyright_representatives, :public_domain, :licensing_restriction_uris, :caption
      ]
    end

    self.model_class = ::GenericWork
    # We must inherit from terms even if we aren't using them because Sufia will pass
    # some of them to the controller and they need to be sanitized properly.
    self.terms += aic_terms
    self.required_fields = [:asset_type, :document_type_uri]

    def primary_terms
      self.class.aic_terms - [:asset_type, :external_resources]
    end

    def secondary_terms
      []
    end

    def asset_type
      AssetTypeAssignmentService.new(model).current_type.first
    end

    def uris_for(term)
      model.send(term).map(&:uri).map(&:to_s)
    end

    def uri_for(term)
      return unless model.send(term)
      model.send(term).uri.to_s
    end

    # @return [Array<SolrDocument>]
    def representation_of_uris
      model.representation_of_uris.map { |uri| SolrDocument.find(ActiveFedora::Base.uri_to_id(uri)) }
    end

    # @return [Array<SolrDocument>]
    def document_of_uris
      model.document_of_uris.map { |uri| SolrDocument.find(ActiveFedora::Base.uri_to_id(uri)) }
    end

    # @return [Array<SolrDocument>]
    def attachment_of_uris
      model.attachment_of_uris.map { |uri| SolrDocument.find(ActiveFedora::Base.uri_to_id(uri)) }
    end

    # @return [Array<SolrDocument>]
    def attachment_ids
      InboundAssetReference.new(model.id).attachments
    end
  end
end
