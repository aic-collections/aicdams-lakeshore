# frozen_string_literal: true
module Lakeshore
  class Ingest
    include ActiveModel::Validations

    attr_reader :ingestor, :submitted_asset_type, :document_type_uri, :original_file,
                :intermediate_file, :presevation_master_file, :additional_files

    validates :ingestor, :asset_type, :document_type_uri, :intermediate_file, presence: true

    # @param [ActionController::Parameters] params from the controller
    def initialize(params)
      @submitted_asset_type = params.fetch(:asset_type)
      register_files(params.fetch(:content, {}))
      register_terms(params.fetch(:metadata, {}))
    end

    def asset_type
      return AICType.send(submitted_asset_type) if AICType.respond_to?(submitted_asset_type)
      errors.add(:asset_type, "#{submitted_asset_type} is not a registered asset type")
    end

    def files
      return [] unless valid?
      [original_upload, intermediate_upload, presevation_master_upload].compact + additional_uploads
    end

    private

      def register_terms(metadata)
        return unless metadata.present?
        @document_type_uri = metadata.fetch(:document_type_uri, nil)
        @ingestor = User.find_by_email(metadata.fetch(:depositor, nil))
      end

      def register_files(content)
        return unless content.present?
        @original_file = content.delete(:original)
        @intermediate_file = content.delete(:intermediate)
        @presevation_master_file = content.delete(:pres_master)
        @additional_files = content
      end

      def original_upload
        return unless original_file
        Sufia::UploadedFile.create(file: original_file,
                                   user: ingestor,
                                   use_uri: AICType.OriginalFileSet).id.to_s
      end

      def intermediate_upload
        return unless intermediate_file
        Sufia::UploadedFile.create(file: intermediate_file,
                                   user: ingestor,
                                   use_uri: AICType.IntermediateFileSet).id.to_s
      end

      def presevation_master_upload
        return unless presevation_master_file
        Sufia::UploadedFile.create(file: presevation_master_file,
                                   user: ingestor,
                                   use_uri: AICType.PreservationMasterFileSet).id.to_s
      end

      def additional_uploads
        additional_files.values.map do |file|
          Sufia::UploadedFile.create(file: file, user: ingestor)
        end
      end
  end
end
