# frozen_string_literal: true
# Data object representing a notification sent to CITI when the representative image
# of an asset is changed.
class CitiNotification
  attr_reader :file_set, :citi_resource

  delegate :citi_uid, to: :citi_resource

  # @param [FileSet] file_set
  # @param [CitiResource, SolrDocument] citi_resource such as a work, exhibit
  def initialize(file_set, citi_resource)
    @file_set = file_set
    @citi_resource = citi_resource
  end

  # @return [String]
  # This is main method used in the class. Returns a json object that will be
  # send to CITI with the details of a given resource and its related file set.
  def to_json
    {
      uid: uid,
      password: password,
      citi_uid: citi_uid,
      type: type,
      lake_image_uid: image_uid,
      last_modified: last_modified,
      asset_details: { image_number: imaging_uid }
    }.to_json
  end

  protected

    def uid
      ENV.fetch("citi_api_uid")
    end

    def password
      ENV.fetch("citi_api_password")
    end

    # TODO: Need a common interface for AF:Base and SolrDocument to return its model name
    def type
      if citi_resource.is_a?(ActiveFedora::Base)
        citi_resource.class.to_s
      else
        citi_resource.hydra_model.to_s
      end
    end

    def last_modified
      return unless file_set && file_set.original_file
      file_set.original_file.fcrepo_modified.first.iso8601
    end

    def image_uid
      return unless file_set
      file_set.id
    end

    def imaging_uid
      return unless file_set && file_set.parent.respond_to?(:imaging_uid)
      file_set.parent.imaging_uid.first
    end
end
