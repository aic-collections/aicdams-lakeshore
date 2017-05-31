# frozen_string_literal: true
# Data object representing a notification sent to CITI when the representative image
# of an asset is changed.
class CitiNotification
  attr_reader :file_set, :citi_resource

  delegate :citi_uid, to: :citi_resource

  # @param [FileSet] file_set
  # @param [CitiResource] citi_resource such as a work, exhibit
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
      image_uid: image_uid,
      last_modified: last_modified,
      asset_details: asset_details
    }.to_json
  end

  protected

    def uid
      ENV.fetch("citi_api_uid")
    end

    def password
      ENV.fetch("citi_api_password")
    end

    def type
      citi_resource.class.to_s
    end

    def last_modified
      return unless file_set && file_set.original_file
      file_set.original_file.fcrepo_modified.first.iso8601
    end

    def image_uid
      return unless file_set
      file_set.id
    end

    def asset_details
      return {} unless citi_resource.respond_to?(:imaging_uid)
      { image_number: citi_resource.imaging_uid.first }
    end
end
