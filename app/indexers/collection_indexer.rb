# frozen_string_literal: true
class CollectionIndexer < CurationConcerns::CollectionIndexer
  include IndexingBehaviors
  include IndexesDepositors

  def generate_solr_document
    super.tap do |solr_doc|
      solr_doc[Solrizer.solr_name("publish_channels", :facetable)] = object.publish_channels.map(&:pref_label)
      solr_doc[Solrizer.solr_name("publish_channels", :symbol)] = object.publish_channels.map(&:pref_label)
      solr_doc[Solrizer.solr_name("collection_type", :facetable)] = pref_label_for(:collection_type)
      solr_doc[Solrizer.solr_name("collection_type", :symbol)] = pref_label_for(:collection_type)
    end
  end
end
