# frozen_string_literal: true
class GenericWork < Resource
  include ::CurationConcerns::WorkBehavior
  include Sufia::WorkBehavior
  include StillImageMetadata
  include TextMetadata
  include AssetMetadata
  include Permissions

  self.human_readable_type = 'Asset'
  self.indexer = AssetIndexer

  def self.aic_type
    super << AICType.Asset
  end

  type type + aic_type

  before_create :status_is_active, :public_is_false
  around_save :reindex_relations
  validate :id_matches_uid_checksum, on: :update

  # Overrides CurationConcerns::Noid to set #id to be a MD5 checksum of #uid.
  def assign_id
    self.uid = service.mint unless new_record? && uid.present?
    self.id = service.hash(uid)
  end

  def status_is_active
    self.status = ListItem.active_status.uri
  end

  # Public domain defaults to false if no value is present.
  # Note: we return :true: so the object will save properly.
  def public_is_false
    return if public_domain.present?
    self.public_domain = false
    true
  end

  def id_matches_uid_checksum
    errors.add :uid, 'must match checksum' if id != service.hash(uid)
  end

  # Re-indexes objects related to the asset, as defined in representations_of, preferred representations_of,
  # documents_of, and attachments_of. In order to account for existing as well as removed relationships,
  # we need to query for them in solr, where they still exist prior to calling #save.
  def reindex_relations
    ids = solr_relation_ids + relation_ids - (solr_relation_ids & relation_ids)
    yield
    ids.uniq.map { |id| reindex_related_resource(id) }
  end

  def asset_has_relationships?
    attachment_of.present? || document_of.present? || preferred_representation_of.present? || representation_of.present?
  end

  # CurationConcerns' title is required, and is multivalued
  # We will allow it be empty, or return the pref. label as an array
  def title
    return [] unless pref_label
    [pref_label]
  end

  # Used by Sufia::WorkIndexer, although may not be required
  # Aliased to document_type
  def resource_type
    document_type
  end

  def original_file_set
    members.select { |f| f.type.include?(AICType.OriginalFileSet) }
  end

  def intermediate_file_set
    members.select { |f| f.type.include?(AICType.IntermediateFileSet) }
  end

  def preservation_file_set
    members.select { |f| f.type.include?(AICType.PreservationMasterFileSet) }
  end

  def legacy_file_set
    members.select { |f| f.type.include?(AICType.LegacyFileSet) }
  end

  private

    def service
      @service ||= UidMinter.new(assignment_service.prefix)
    end

    def assignment_service
      @assignment_service ||= AssetTypeAssignmentService.new(self)
    end

    def relation_ids
      attachment_of.map(&:id) +
        document_of.map(&:id) +
        representation_of.map(&:id) +
        preferred_representation_of.map(&:id)
    end

    def solr_relation_ids(ids = [])
      return ids if id.nil?
      solr_document = SolrDocument.find(id)
      ids << solr_document["attachment_of_ssim"]
      ids << solr_document["document_of_ssim"]
      ids << solr_document["representation_of_ssim"]
      ids << solr_document["preferred_representation_of_ssim"]
      ids.flatten.compact
    end

    def reindex_related_resource(id)
      ActiveFedora::Base.find(id).update_index
    rescue ActiveFedora::ObjectNotFoundError
      Rails.logger.warn("Attempted to reindex related resource #{id}, but it was not found in Fedora.")
    end
end
