# frozen_string_literal: true
# File actor for Lakeshore that uses a custom job for ingesting files.
class Lakeshore::Actors::FileActor < CurationConcerns::Actors::FileActor
  def ingest_file(file)
    Lakeshore::IngestFileJob.perform_later(
      file_set,
      working_file(file),
      user,
      ingest_options(file))
    true
  end
end
