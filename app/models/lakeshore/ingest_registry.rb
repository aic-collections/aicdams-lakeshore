# frozen_string_literal: true
module Lakeshore
  class IngestRegistry
    include ActiveModel::Validations

    validate :file_types_must_be_valid

    attr_reader :intermediate_file, :user, :files, :content

    # @param [Hash] content from api request
    # @param [User] user
    def initialize(content, user)
      @intermediate_file = register_intermediate_file(content.delete(:intermediate), user)
      @content = content
      @user = user
      @files = [@intermediate_file].compact
      register_files if valid?
    end

    # @param [true, false] if there are no duplicates in the set of files
    def unique?
      duplicates.empty?
    end

    # @return [Array<String>]
    # Array of numeric ids for each Sufia::UploadedFile in the array of {files}
    def upload_ids
      return [] if duplicates.present?
      files.map(&:uploaded_file_id).compact
    end

    # @return [Hash]
    # @note creates a JSON report for duplicate typed and non-typed files
    def duplicate_error
      error = { message: "Duplicate files detected." }
      IngestFile.types.each do |type|
        error_files = duplicates.select { |file| (file.type == type) }
        next if error_files.empty?
        error[type] = error_files.map { |file| error_details(file) }
      end

      untyped_duplicates = duplicates.select { |file| file.type.nil? }
      if untyped_duplicates.present?
        error[:other] = untyped_duplicates.map { |file| error_details(file) }
      end

      error
    end

    private

      def register_intermediate_file(file, user)
        file = IngestFile.new(user: user, file: file, type: :intermediate, batch_id: uploaded_batch.id)
        return if file.file.nil?
        file
      end

      def register_files
        content.keys.map(&:to_sym).each do |type|
          files << IngestFile.new(user: user, file: content.delete(type), type: type, batch_id: uploaded_batch.id)
        end
      end

      def file_types_must_be_valid
        invalid_types = (content.keys.map(&:to_sym) - IngestFile.uri_map.keys)
        return unless invalid_types.present?
        errors.add(:files, "Request contains invalid file types: #{invalid_types.join(', ')}")
      end

      def duplicates
        @duplicates ||= files.select(&:duplicate?)
      end

      def error_details(file)
        {
          error: "#{file.errors.messages[:checksum].first[:error]} "\
                 "#{file.errors.messages[:checksum].first[:duplicate_name]}",
          path: file.errors.messages[:checksum].first[:duplicate_path]
        }
      end

      def uploaded_batch
        @uploaed_batch ||= UploadedBatch.create
      end
  end
end
