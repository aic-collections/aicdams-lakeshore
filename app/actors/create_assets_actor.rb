# frozen_string_literal: true
# Works in place Sufia::CreateWithFilesActor so that we control the workflow of asset creation and
# route calls originating from the ingest api to their own jobs, while leaving calls originating
# from the gui to the jobs in the Sufia/CC stack.
class CreateAssetsActor < Sufia::CreateWithFilesActor
  attr_reader :ingest_method

  def create(attributes)
    @ingest_method = attributes.delete(:ingest_method)
    self.uploaded_file_ids = attributes.delete(:uploaded_files)
    validate_files && next_actor.create(attributes) && attach_files
  end

  def update(attributes)
    @ingest_method = attributes.delete(:ingest_method)
    self.uploaded_file_ids = attributes.delete(:uploaded_files)
    validate_files && next_actor.update(attributes) && attach_files
  end

  protected

    # @return [TrueClass]
    def attach_files
      return true unless uploaded_files.present?
      attach_files_job.perform_later(curation_concern, uploaded_files)
      true
    end

  private

    def attach_files_job
      if ingest_method == "api"
        Lakeshore::AttachFilesToWorkJob
      else
        AttachFilesToWorkJob
      end
    end
end
