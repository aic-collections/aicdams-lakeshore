class AssetIndexer < ActiveFedora::IndexingService

  def generate_solr_document
    super.tap do |solr_doc|
      solr_doc[Solrizer.solr_name("aic_type", :facetable)] = "Asset"
    end
  end

end