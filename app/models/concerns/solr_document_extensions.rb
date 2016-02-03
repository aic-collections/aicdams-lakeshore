module SolrDocumentExtensions
  extend ActiveSupport::Concern
  include LakeshorePermissions

  def title_or_label
    title || pref_label
  end

  def pref_label
    Array(self[Solrizer.solr_name('pref_label', :stored_searchable)]).first
  end

  def title
    if Array(self[Solrizer.solr_name('title')]).empty?
      pref_label
    else
      Array(self[Solrizer.solr_name('title')]).first
    end
  end

  def uid
    Array(self[Solrizer.solr_name('uid', :symbol)]).first
  end

  def main_ref_number
    Array(self[Solrizer.solr_name('main_ref_number', :stored_searchable)]).first
  end
end
