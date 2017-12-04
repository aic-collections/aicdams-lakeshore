# frozen_string_literal: true
# Manages the inverse relationships of assets by updating assets when the relationship to a given non-asset
# or asset changes.
class InboundAssetManagementService
  include CurationConcerns::Lockable
  attr_reader :resource, :user, :ids_to_add, :ids_to_remove

  # @param [CitiResource, Asset] resource
  def initialize(resource, user = nil)
    @resource = resource
    @user = user
  end

  # @param [Symbol] relationship of the asset: :documents, :representations, :preferred_representation
  # @param [Array<String>, String] ids_or_uris of the resource(s) that will be updated
  def update(relationship, ids_or_uris)
    ids = Array.wrap(ids_or_uris).map { |id| URI.parse(id).path.split("/").last }
    @ids_to_remove = Array.wrap(representing_resource.send(relationship)).map(&:id) - ids
    @ids_to_add = ids - Array.wrap(representing_resource.send(relationship)).map(&:id)
    remove(relationship) && add(relationship)
  end

  private

    # Removes the given relationship from assets that are not explicitly listed in the array of ids
    def remove(relationship)
      ids_to_remove.each do |old_id|
        acquire_lock_for(old_id) do
          reflection = inverse_relationship(relationship)
          asset = ActiveFedora::Base.find(old_id)
          new_list = asset.send(reflection).map { |r| r unless r.id == resource.id }.compact
          asset.send("#{reflection}_uris=", new_list.map(&:uri))
          asset.save
          notify_citi_of_removal(asset) if relationship == :preferred_representation
        end
      end
    end

    # Updates each of assets in the array of ids and adds the given resource as the relationship for that asset
    def add(relationship)
      ids_to_add.each do |id|
        acquire_lock_for(id) do
          reflection = inverse_relationship(relationship)
          asset = ActiveFedora::Base.find(id)
          new_list = asset.send("#{reflection}_uris") + [resource.uri]
          asset.send("#{reflection}_uris=", new_list)
          asset.save
          notify_citi_of_addition(asset) if relationship == :preferred_representation
        end
      end
    end

    def representing_resource
      @representing_resource ||= InboundAssetReference.new(resource)
    end

    def inverse_relationship(relationship)
      {
        documents: "document_of",
        representations: "representation_of",
        preferred_representation: "preferred_representation_of",
        attachments: "attachment_of"
      }[relationship]
    end

    def notify_citi_of_addition(asset)
      return unless asset.intermediate_file_set.present?
      CitiNotificationJob.perform_later(asset.intermediate_file_set.first, resource)
    end

    def notify_citi_of_removal(asset)
      return unless asset.intermediate_file_set.present? && ids_to_add.empty?
      CitiNotificationJob.perform_later(nil, resource)
    end
end
