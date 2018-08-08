# frozen_string_literal: true

include Rails.application.routes.url_helpers

namespace :derivatives do
  desc "runs CreateDerivativesJob for all MovingImage and Sound intermediate file_sets"
  task sound_and_moving_image_3053: :environment do
    query = "rdf_types_ssim:\"http://definitions.artic.edu/ontology/1.0/type/IntermediateFileSet\""
    fl = "id"
    fq = []
    fq << "{!join from=file_set_ids_ssim to=id}rdf_types_ssim:(\"http://definitions.artic.edu/ontology/1.0/type/MovingImage\" OR \"http://definitions.artic.edu/ontology/1.0/type/Sound\")"
    file_set_ids = ActiveFedora::SolrService.query( query, { fq: fq, fl: fl, rows: 100_000 } ).map(&:id)

    puts "Found #{file_set_ids.count} id's in Solr, that were intermediate file_sets of either MovingImage or Sound assets."

    file_set_ids.each do |file_set_id|
      puts "file_set_id: #{file_set_id}"
      fs = FileSet.find(file_set_id)
      orignal_file_id = fs.original_file.id
      puts "orignal_file_id: #{orignal_file_id}"
      CreateDerivativesJob.perform_later fs, orignal_file_id
    end
  end
end
