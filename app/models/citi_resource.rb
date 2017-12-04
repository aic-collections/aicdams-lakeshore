# frozen_string_literal: true
class CitiResource < Resource
  include CitiResourceMetadata
  include Sufia::WithEvents

  # @todo change _uris to _ids?
  delegate :representations, :representation_uris, :preferred_representation, :preferred_representation_uri,
           :documents, :document_uris, to: :incomming_asset_reference

  def self.aic_type
    super << AICType.CitiResource
  end

  type aic_type

  # Status defaults to active if it is nil
  def status
    super || ListItem.active_status
  end

  private

    def incomming_asset_reference
      @incomming_asset_reference ||= InboundAssetReference.new(self)
    end
end
