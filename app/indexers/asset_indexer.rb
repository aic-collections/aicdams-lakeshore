# frozen_string_literal: true

class AssetIndexer < Sufia::WorkIndexer
  include PrefLabel

  def generate_solr_document
    super.tap do |solr_doc|
      solr_doc[Solrizer.solr_name("aic_type", :facetable)] = aic_types(["Asset"])
      solr_doc[Solrizer.solr_name("representation", :facetable)] = FacetBuilder.new(object).representations
      solr_doc[Solrizer.solr_name("depositor_full_name", :stored_searchable)] = depositor_full_name
      solr_doc[Solrizer.solr_name("aic_depositor", :symbol)] = object.depositor
      solr_doc[Solrizer.solr_name("fedora_uri", :symbol)] = object.uri.to_s
      solr_doc[Solrizer.solr_name("digitization_source", :stored_searchable)] = pref_label_for(:digitization_source)
      solr_doc[Solrizer.solr_name("compositing", :stored_searchable)] = pref_label_for(:compositing)
      solr_doc[Solrizer.solr_name("light_type", :stored_searchable)] = pref_label_for(:light_type)
      solr_doc[Solrizer.solr_name("status", :stored_searchable)] = pref_label_for(:status)
      solr_doc[Solrizer.solr_name("dept_created", :stored_searchable)] = pref_label_for(:dept_created)
      solr_doc[Solrizer.solr_name("dept_created", :facetable)] = pref_label_for(:dept_created)
      solr_doc[Solrizer.solr_name("document_types", :stored_searchable)] = document_types_display
      solr_doc[Solrizer.solr_name("document_types", :facetable)] = document_types_facet
      solr_doc[Solrizer.solr_name("publish_channels", :facetable)] = object.publish_channels.map(&:pref_label)
      solr_doc[Solrizer.solr_name("publish_channels", :symbol)] = object.publish_channels.map(&:pref_label)
      solr_doc[Solrizer.solr_name("attachments", :symbol)] = object.attachments.map(&:id)
      solr_doc[Solrizer.solr_name("related_works", :symbol)] = FacetBuilder.new(object).related_works
    end
  end

  private

    def aic_types(types)
      types << "Still Image" if object.type.include?(AICType.StillImage)
      types << "Text" if object.type.include?(AICType.Text)
      types
    end

    def document_types_facet(types = [])
      types << pref_label_for(:document_type)
      types << pref_label_for(:first_document_sub_type)
      types << pref_label_for(:second_document_sub_type)
      types.compact
    end

    def document_types_display
      [
        pref_label_for(:document_type),
        pref_label_for(:first_document_sub_type),
        pref_label_for(:second_document_sub_type)
      ].compact.join(" > ")
    end

    def depositor_full_name
      return unless object.aic_depositor
      return object.aic_depositor.nick unless object.aic_depositor.given_name && object.aic_depositor.family_name
      [[object.aic_depositor.given_name, object.aic_depositor.family_name].join(" ")]
    end

    class FacetBuilder
      attr_reader :object

      def initialize(object)
        @object = object
      end

      def representations
        [
          attachment_facet, attachment_of_facet, documentation_facet,
          representation_facet, preferred_representation_facet
        ].compact
      end

      def attachment_facet
        return if object.attachments.empty?
        "Has Attachment"
      end

      def attachment_of_facet
        return if relationships.attachments.empty?
        "Is Attachment Of"
      end

      def documentation_facet
        return if relationships.documents.empty?
        "Documentation For"
      end

      def representation_facet
        return if relationships.representations.empty?
        "Is Representation"
      end

      def preferred_representation_facet
        return if relationships.preferred_representation.nil?
        "Is Preferred Representation"
      end

      # related_works creates a json structure of the asset's representations and preferred representations, containing only the citi_uids and main_ref_numbers of each representation.

      def related_works
        return if relationships.representations.empty? && relationships.preferred_representation.nil?

        all_related_works = relationships.representations + preferreds

        related_works = all_related_works.map do |r|
          related_work(r)
        end.compact

        related_works.uniq.to_json
      end

      private

        def relationships
          @relationships ||= InboundRelationships.new(object.id)
        end

        def valid_work?(work)
          if ((work.type.include? AICType.CitiResource) && work.citi_uid.present?) && ((work.respond_to? "main_ref_number") && work.main_ref_number.present?)
            return true
          end
          false
        end

        def related_work(work)
          if valid_work?(work)
            { "citi_uid": work.citi_uid, "main_ref_number": work.main_ref_number }
          end
        end

        def preferreds
          relationships.preferred_representations.count == 1 ? [relationships.preferred_representation] : relationships.preferred_representations
        end
    end
end
