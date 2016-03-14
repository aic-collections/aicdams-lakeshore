class CitiResource < Resource
  include CitiResourceMetadata

  def self.aic_type
    super << AICType.CitiResource
  end

  type aic_type

  around_save :reindex_relations

  # Status defaults to active if it is nil
  def status
    super || StatusType.active
  end

  # Re-indexes related objects, i.e. representations, preferred representations, and documents, including
  # those of relations that have just been removed. To do so, we need to query for these relationships
  # in solr, which still exist prior to calling #save.
  def reindex_relations
    ids = solr_relation_ids + relation_ids
    yield
    ids.uniq.map { |id| ActiveFedora::Base.find(id).update_index }
  end

  private

    def relation_ids
      [document_ids, representation_ids, preferred_representation_ids].flatten
    end

    def solr_relation_ids
      return [] if id.nil?
      ActiveFedora::SolrService.query(
        "id:#{id}",
        fl: "hasDocument_ssim, hasPreferredRepresentation_ssim, hasRepresentation_ssim"
      ).first.values.flatten
    end
end
