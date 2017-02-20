# frozen_string_literal: true
# Overrides: sufia app/jobs/attach_files_to_work_job.rb
# Converts UploadedFiles into FileSets and attaches them to works.
class AttachFilesToWorkJob < ActiveJob::Base
  queue_as :ingest
  include AddingFilesToWorks
end
