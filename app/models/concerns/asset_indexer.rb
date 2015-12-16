class AssetIndexer < ActiveFedora::IndexingService
  def generate_solr_document
    super.tap do |solr_doc|
      solr_doc[Solrizer.solr_name("aic_type", :facetable)] = aic_types(["Asset"])
      solr_doc[Solrizer.solr_name("file_size", :stored_sortable, type: :integer)] = object.file_size.first
      solr_doc[Solrizer.solr_name("image_height", :searchable, type: :integer)] = object.height
      solr_doc[Solrizer.solr_name("image_width", :searchable, type: :integer)] = object.width
    end
  end

  private

    def aic_types(types)
      types << "Still Image" if object.type.include?(AICType.StillImage)
      types << "Text" if object.type.include?(AICType.Text)
      types
    end
end
