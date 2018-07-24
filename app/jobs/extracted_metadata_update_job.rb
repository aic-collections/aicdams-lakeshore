# frozen_string_literal: true
class ExtractedMetadataUpdateJob < ActiveJob::Base
  # @param [FileSet] file_set
  # @param [String] file_id identifier for a Hydra::PCDM::File
  # @param [String, NilClass] filepath the cached file within the CurationConcerns.config.working_path
  def perform(file_set, file_id = nil, filepath = nil)
    parent = file_set.parent
    update_parent(file_set, parent) if parent.created.nil?
    CreateDerivativesJob.perform_later(file_set, file_id, filepath) # unless file_id.nil?
  end

  # @note We prefer file created dates from an original file set.
  def update_parent(file_set, parent)
    raise Lakeshore::JobError, "File set #{file_set.id} is missing its original file" unless file_set.original_file
    if file_set.type.include?(AICType.OriginalFileSet)
      update_created_attribute(file_set, parent)
    elsif file_set.type.include?(AICType.IntermediateFileSet)
      update_created_attribute(file_set, parent)
    end
  end

  def update_created_attribute(file_set, parent)
    parent.created = file_set.original_file.date_created.first
    return if parent.created.nil?
    parent.save
  end
end
