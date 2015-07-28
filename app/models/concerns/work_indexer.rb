class WorkIndexer < ActiveFedora::IndexingService

  def generate_solr_document
    super.tap do |solr_doc|
      solr_doc["read_access_group_ssim"] = "public"
      solr_doc[Solrizer.solr_name("aic_type", :facetable)] = "Work"
    end
  end

end
