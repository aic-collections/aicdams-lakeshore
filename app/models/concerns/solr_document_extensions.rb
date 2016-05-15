# frozen_string_literal: true
module SolrDocumentExtensions
  extend ActiveSupport::Concern
  include Permissions::Readable

  def pref_label
    Array(self[Solrizer.solr_name('pref_label', :stored_searchable)]).first
  end

  def uid
    Array(self[Solrizer.solr_name('uid', :symbol)]).first
  end

  def main_ref_number
    Array(self[Solrizer.solr_name('main_ref_number', :stored_searchable)]).first
  end
end
