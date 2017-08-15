# frozen_string_literal: true
module SolrSupport
  def index_assets(*docs)
    docs.each do |doc|
      ActiveFedora::SolrService.add(doc.to_solr)
      ActiveFedora::SolrService.commit
    end
  end
end
