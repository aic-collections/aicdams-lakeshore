# frozen_string_literal: true
# Service class for constructing Solr fields found in GenericWork resources
class AssetSolrFieldBuilder
  attr_reader :asset

  def initialize(asset)
    @asset = asset
  end

  # @return [String, Array<String]
  # Returns a listing of representation facets. If none exist, it returns "No Relationship"
  def representations
    representations = [
      attachment_facet, has_attachment_facet, documentation_facet,
      representation_facet, preferred_representation_facet
    ].compact
    representations.empty? ? "No Relationship" : representations
  end

  # @return [String]
  def attachment_facet
    return if asset.attachment_of.empty?
    "Is Attachment"
  end

  # @return [String]
  # rubocop:disable Style/PredicateName
  def has_attachment_facet
    return if relationships.attachments.empty?
    "Has Attachment"
  end
  # rubocop:enable Style/PredicateName

  # @return [Array<String>]
  # rubocop:disable Style/PredicateName
  def has_attachment_ids
    relationships.attachments.map(&:id)
  end
  # rubocop:enable Style/PredicateName

  # @return [String]
  def documentation_facet
    return if asset.document_of.empty?
    "Documentation For"
  end

  # @return [String]
  def representation_facet
    return if asset.representation_of.empty?
    "Is Representation"
  end

  # @return [String]
  def preferred_representation_facet
    return if asset.preferred_representation_of.empty?
    "Is Preferred Representation"
  end

  # @return [String]
  # A json structure of the asset's representations and preferred representations, containing only the
  # citi_uids and main_ref_numbers of each representation.
  def related_works
    valid_related_works.map do |work|
      { "citi_uid": work.citi_uid, "main_ref_number": work.main_ref_number }
    end.compact.uniq.to_json
  end

  # @return [Array<String>]
  # Only the main_ref_number properties for related works
  def main_ref_numbers
    valid_related_works.map(&:main_ref_number).uniq
  end

  private

    def relationships
      @relationships ||= InboundAssetReference.new(asset.id)
    end

    def valid_work?(work)
      if ((work.type.include? AICType.CitiResource) && work.citi_uid.present?) && ((work.respond_to? "main_ref_number") && work.main_ref_number.present?)
        return true
      end
      false
    end

    def valid_related_works
      all_related_works = asset.representation_of.to_a + asset.preferred_representation_of.to_a
      all_related_works.map { |w| w if valid_work?(w) }.compact
    end
end
