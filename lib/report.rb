# frozen_string_literal: true
class Report
  attr_reader :table

  def initialize(file)
    @table = CSV.read(file, headers: true)
  end

  def sets
    @sets ||= table.group_by { |row| row['imaging_uid'] }
  end

  def call
    sets.map do |_uid, set|
      preferred_representation = set
                                 .select { |row| row['preferred_representation'] }
                                 .map { |row| row['preferred_representation'] }.first
      asset_to_keep = set.max_by { |row| row['master_height'].to_i }
      assets_to_delete = set.reject { |row| row['uid'] == asset_to_keep['uid'] }

      RemoveDuplicateJob.perform_later(
        asset_to_keep: asset_to_keep['uid'],
        assets_to_delete: assets_to_delete.map { |asset| asset['uid'] },
        preferred_representation: preferred_representation
      )
    end
  end

  class RemoveDuplicateJob < ActiveJob::Base
    queue_as :release

    def perform(asset_to_keep:, assets_to_delete:, preferred_representation: nil)
      update(asset_uid: asset_to_keep, preferred_representation: preferred_representation)
      assets_to_delete.each { |asset| delete(asset) }
    end

    def update(asset_uid:, preferred_representation:)
      asset = GenericWork.find_by_uid(asset_uid)
      return unless asset

      if preferred_representation
        citi_resource = ActiveFedora::Base.find(preferred_representation)
        service = InboundRelationshipManagementService.new(asset)
        service.add_or_remove(:representations, [preferred_representation])
        citi_resource.preferred_representation_uri = asset.uri.to_s
        citi_resource.save
      end

      asset.reload
      asset.publish_channels = [web_channel]
      asset.save
    end

    def delete(asset_uid)
      asset = GenericWork.find_by_uid(asset_uid)
      return unless asset

      service = InboundRelationshipManagementService.new(asset)
      service.add_or_remove(:representations, [])
      service.add_or_remove(:documents, [])
      service.add_or_remove(:attachments, [])
      asset.delete
    end

    def web_channel
      PublishChannel.find("http://definitions.artic.edu/publish_channel/Web")
    end
  end
end
