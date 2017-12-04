# frozen_string_literal: true
module CitiFormBehaviors
  extend ActiveSupport::Concern

  included do
    self.terms += [:document_ids, :representation_ids, :preferred_representation_id]
    delegate :documents, :document_ids, :preferred_representation_id, to: :inbound_asset_reference

    def self.build_permitted_params
      super + [{ document_ids: [] }, { representation_ids: [] }]
    end
  end

  # Insert the preferred representation at the beginning of the array to ensure it is always first
  def representations
    inbound_asset_reference.representations.insert(0, inbound_asset_reference.preferred_representation).compact.uniq
  end

  def representation_ids
    representations.map(&:id).uniq
  end

  # @return [SolrDocument]
  # @note use an empty SolrDocument as a null object pattern when preferred representation is nil
  # @todo I'm not sure this method needs to be used anymore
  def preferred_representation
    inbound_asset_reference.preferred_representation || SolrDocument.new({})
  end

  def preferred_representation_thumbnail
    Sufia::WorkThumbnailPathService.call(preferred_representation)
  end

  private

    def inbound_asset_reference
      @inbound_asset_reference ||= InboundAssetReference.new(model)
    end
end
