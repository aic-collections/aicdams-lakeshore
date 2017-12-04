# frozen_string_literal: true
class AssetActor < CurationConcerns::Actors::BaseActor
  def create(attributes)
    override_dept_created(attributes.delete("dept_created"))
    asset_type = RDF::URI(attributes.delete("asset_type"))
    AssetTypeAssignmentService.new(curation_concern).assign(asset_type)
    apply_dates(updated: attributes.delete("updated"), created: attributes.delete("created"))
    assign_copyright_representatives(attributes.delete("copyright_representatives"))
    management_service.update(:attachments, attributes.delete("attachment_ids"))
    super
  end

  def update(attributes)
    attributes.delete("asset_type")
    apply_dates(updated: attributes.delete("updated"), created: attributes.delete("created"))
    assign_copyright_representatives(attributes.delete("copyright_representatives"))
    remove_preferred_representation(attributes.fetch("representation_of_uris", []))
    management_service.update(:attachments, attributes.delete("attachment_ids"))
    super
  end

  def override_dept_created(dept)
    return unless dept
    curation_concern.dept_created = Department.find_by_citi_uid(dept).uri
  end

  # @param [Hash] terms
  # Attempts to parse the values of each key into dates and set the object's property using
  # the key as the property. A failure will not change the existing value and a message is
  # written to the log.
  # Note: Does not work with multivalued properties.
  def apply_dates(terms)
    terms.each do |k, v|
      next unless v.present?
      parse_date(k, v)
    end
  end

  def assign_copyright_representatives(reps)
    return if reps.nil?
    new_representatives = build_representatives(reps)
    curation_concern.copyright_representative_uris = new_representatives
  end

  # @note If all representations have been removed, then any that were preferred representations must be
  #       removed as well.
  def remove_preferred_representation(representation_uris)
    removed_representations = curation_concern.representation_of_uris - representation_uris
    return if removed_representations.empty?
    updated_preferreds = curation_concern.preferred_representation_of_uris.reject! { |p| removed_representations.include?(p) }
    curation_concern.preferred_representation_of_uris = updated_preferreds
  end

  private

    def parse_date(property, value)
      curation_concern.send("#{property}=", Date.parse(value))
    rescue ArgumentError
      Rails.logger.error("Unable to parse #{value} into date for property #{property}")
    end

    def build_representatives(reps)
      reps.map do |id|
        Agent.find(id).uri
      end
    end

    def management_service
      @management_service ||= InboundAssetManagementService.new(curation_concern, user)
    end
end
