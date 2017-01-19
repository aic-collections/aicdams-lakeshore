# frozen_string_literal: true
class FileSetReplacementService
  attr_reader :asset, :file, :user

  # @param [GenericWork] asset
  # @param [String] id of Sufia::UploadedFile
  # @param [User] user performing the actions, usually current_user from a controller or actor
  def initialize(asset, id, user)
    @asset = asset
    @file = Sufia::UploadedFile.find(id)
    @user = user
  end

  def replaced?
    if intermediate_file_set && file.use_uri == AICType.IntermediateFileSet
      replace(intermediate_file_set)
    elsif original_file_set && file.use_uri == AICType.OriginalFileSet
      replace(original_file_set)
    elsif preservation_file_set && file.use_uri == AICType.PreservationMasterFileSet
      replace(preservation_file_set)
    elsif legacy_file_set && file.use_uri == AICType.LegacyFileSet
      replace(legacy_file_set)
    else
      false
    end
  end

  def replace(file_set)
    file_set.title = [file.file.file.original_filename]
    file_set.save!
    CurationConcerns::Actors::FileActor.new(file_set, "original_file", user).ingest_file(file.file)
    true
  end

  private

    def intermediate_file_set
      @intermediate_file_set ||= asset.intermediate_file_set.first
    end

    def original_file_set
      @original_file_set ||= asset.original_file_set.first
    end

    def preservation_file_set
      @preservation_file_set ||= asset.preservation_file_set.first
    end

    def legacy_file_set
      @legacy_file_set ||= asset.legacy_file_set.first
    end
end
