# frozen_string_literal: true
# Models the relationship between resources and their related assets. These could be CITI resources, which contain
# other assets as representations or documents; or these could be assets themselves which can contain other
# assets as attachments. Because the relationship between an asset the resource it represents is modeled
# directly in Fedora, ex. representation of, document of, etc., we need a way to model the inverse of this
# relationship: a resource and its representative assets.
#
# @example Given two assets that are representations of the same CITI resource:
#
#   >  asset1.representation_of = [citi_resource]
#   >  asset2.representation_of = [citi_resource]
#
# We can find the assets given the CITI resource:
#
#  >  InboundAssetReference.new(citi_resource).representations
#  => [asset1, asset2]
#
# @example Given an asset that is an attachment of two other assets:
#
#  >  asset1.attachment_of = [asset2]
#
#  >  InboundAssetReference.new(asset2).attachments
#  => [asset1]

class InboundAssetReference
  attr_reader :id

  # @param [CitiResource, GenericWork, String] resource as an object or string identifier
  def initialize(resource)
    @id = resource.is_a?(ActiveFedora::Base) ? resource.id : resource
  end

  # @return [Array<SolrDocument>]
  def representations
    @representations ||= assets_with(:representation_of_ssim)
  end

  # @return [Array<String>]
  def representation_ids
    @representation_ids ||= ids_with(:representation_of_ssim)
  end

  # @return [Array<SolrDocument>]
  # @todo if a citi_resource has multiple preferred representations, that might be a problem and we should report it.
  #       For now, this method is here as a convenience.
  def preferred_representations
    @preferred_representations ||= assets_with(:preferred_representation_of_ssim)
  end

  # @return [SolrDocument]
  def preferred_representation
    preferred_representations.first
  end

  # @return [Array<String>]
  # @todo if a citi_resource has multiple preferred representations, that might be a problem and we should report it.
  #       For now, this method is here as a convenience.
  def preferred_representation_ids
    @preferred_representation_ids ||= ids_with(:preferred_representation_of_ssim)
  end

  # @return [String]
  def preferred_representation_id
    preferred_representation_ids.first
  end

  # @return [Array<SolrDocument>]
  def documents
    @documents ||= assets_with(:document_of_ssim)
  end

  # @return [Array<String>]
  def document_ids
    @document_ids ||= ids_with(:document_of_ssim)
  end

  # @return [Array<SolrDocument>]
  def attachments
    @attachments ||= assets_with(:attachment_of_ssim)
  end

  # @return [Array<String>]
  def attachment_ids
    @attachments_ids ||= ids_with(:attachment_of_ssim)
  end

  private

    def assets_with(solr_field)
      return [] if id.nil?
      ActiveFedora::SolrService.query("#{solr_field}:#{id}").map { |hit| SolrDocument.new(hit) }
    end

    def ids_with(solr_field)
      return [] if id.nil?
      ActiveFedora::SolrService.query("{!field f=#{solr_field}}#{id}", fl: ActiveFedora.id_field)
                               .map { |x| x.fetch(ActiveFedora.id_field) }
    end
end
