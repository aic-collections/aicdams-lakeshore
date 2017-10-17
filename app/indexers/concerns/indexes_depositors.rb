# frozen_string_literal: true

module IndexesDepositors
  include ActiveSupport::Concern

  def generate_solr_document
    super.tap do |solr_doc|
      solr_doc[Solrizer.solr_name("depositor_full_name", :stored_searchable)] = depositor_full_name
      solr_doc[Solrizer.solr_name("aic_depositor", :symbol)] = object.depositor
      solr_doc[Solrizer.solr_name("dept_created", :stored_searchable)] = pref_label_for(:dept_created)
      solr_doc[Solrizer.solr_name("dept_created", :facetable)] = pref_label_for(:dept_created)
      solr_doc[Solrizer.solr_name("dept_created_citi_uid", :symbol)] = citi_uid_for(:dept_created)
    end
  end
end
