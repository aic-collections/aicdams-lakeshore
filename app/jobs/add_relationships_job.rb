# frozen_string_literal: true
class AddRelationshipsJob < ActiveJob::Base
  queue_as :resource

  def perform(curation_concern:, user:, representation_ids:, document_ids:, attachment_uris:,
              constituent_uris:, preferred_representation_ids:)
    management_service = InboundRelationshipManagementService.new(curation_concern, user)
    management_service.add_or_remove_representations(representation_ids)
    management_service.add_or_remove(:documents, document_ids)
    management_service.add_or_remove(:attachments, attachment_uris)
    management_service.add_or_remove(:constituents, constituent_uris)
    management_service.update(:preferred_representations, preferred_representation_ids)
  end
end
