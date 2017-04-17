# frozen_string_literal: true
class CreateAssetJob < CreateWorkJob
  before_perform do |job|
    job.arguments[2].fetch(:uploaded_files, []).each do |id|
      file = Sufia::UploadedFile.find(id)
      unless DuplicateUploadVerificationService.unique?(file)
        raise Lakeshore::DuplicateAssetError
      end
    end
  end
end
