module SolrDocumentExtensions
  extend ActiveSupport::Concern

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

end
