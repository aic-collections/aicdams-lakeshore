# frozen_string_literal: true
module SolrDocumentExtensions::Asset
  extend ActiveSupport::Concern

  def capture_device
    Array(self[Solrizer.solr_name('capture_device', :stored_searchable)]).first
  end

  def digitization_source
    Array(self[Solrizer.solr_name('digitization_source', :stored_searchable)]).first
  end

  def document_type
    Array(self[Solrizer.solr_name('document_type', :symbol)]).first
  end

  def first_document_sub_type
    Array(self[Solrizer.solr_name('first_document_sub_type', :symbol)]).first
  end

  def second_document_sub_type
    Array(self[Solrizer.solr_name('second_document_sub_type', :symbol)]).first
  end

  def legacy_uid
    Array(self[Solrizer.solr_name('legacy_uid', :stored_searchable)])
  end

  def keyword
    Array(self[Solrizer.solr_name('keyword', :stored_searchable)])
  end
end
