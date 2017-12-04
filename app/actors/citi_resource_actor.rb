# frozen_string_literal: true
# Common actor for all CITI resources
class CitiResourceActor < CurationConcerns::Actors::BaseActor
  # @param [Hash] attributes from the form
  def update(attributes)
    representations = Array.wrap(attributes.delete("representation_ids"))
    documents = attributes.delete("document_ids")
    management_service.update(:representations, representations)
    management_service.update(:documents, documents)
    management_service.update(:preferred_representation, representations.first)
    super
  end

  protected

    def management_service
      @management_service ||= InboundAssetManagementService.new(curation_concern, user)
    end
end
