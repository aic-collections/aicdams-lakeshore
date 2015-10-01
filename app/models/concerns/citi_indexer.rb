# Indexes resources loaded into Fedora from CITI.
class CitiIndexer < ActiveFedora::IndexingService

  def generate_solr_document
    super.tap do |solr_doc|
      solr_doc["read_access_group_ssim"] = "public"
      solr_doc[Solrizer.solr_name("aic_type", :facetable)] = self.object.class.to_s
    end
  end

end
