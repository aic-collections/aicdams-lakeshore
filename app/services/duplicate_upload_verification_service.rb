# frozen_string_literal: true
class DuplicateUploadVerificationService
  attr_reader :duplicates, :file

  # @param [Rack::Test::UploadedFile] file uploaded via Rack
  def initialize(file)
    @file = file
  end

  def duplicates
    existing_filesets.empty? ? [] : [GenericWork.find(existing_filesets.first.parent.id)]
  end

  private

    # Calculate the SHA1 checksum and format it like Fedora does
    def fedora_shasum
      "urn:sha1:#{Digest::SHA1.file(file_path)}"
    end

    def existing_filesets
      FileSet.where(digest_ssim: fedora_shasum)
    end

    def file_path
      return file.path if file.respond_to?(:path)
      file.file.file.path
    end
end
