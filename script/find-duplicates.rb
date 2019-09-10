# frozen_string_literal: true
# Generates a report of duplicate assets based on an exported Solr query
# @example
#   bundle exec rails runner script/find-duplicates.rb tmp/select.json
#
# q=*%3A*&fq=has_model_ssim%3AGenericWork&wt=json&indent=true&qt=search&facet.limit=1000000&facet.field=imaging_uid_ssim&facet.mincount=2&facet=true

require 'pry'

def options
  @options ||= OpenStruct.new
end

ARGV.options do |opts|
  opts.on("-o", "--output=", "File to write", String)     { |val| options.output = val }
  opts.on("-s", "--solr=", "Solr connection url", String) { |val| options.solr = val }

  opts.on_tail("-h", "--help") do
    puts opts
    exit
  end

  opts.parse!
end

unless ARGV[0]
  puts "Solr result file is required"
  exit(1)
end

def solr_connection
  options.solr || 'http://localhost:8983/solr/hydra-development'
end

def output_file
  options.output || 'report.csv'
end

def imaging_uids
  file = File.open(ARGV[0])
  json = JSON.parse(file.read)
  json["facet_counts"]["facet_fields"]["imaging_uid_ssim"].reject { |element| element.is_a?(Fixnum) }
end

def add_assets(csv: csv, id: id)
  assets = ActiveFedora::SolrService.query("imaging_uid_ssim:#{id}")
  assets.map { |asset| add_solr_document(csv: csv, document: SolrDocument.new(asset), id: id) }
rescue StandardError => exception
  puts "Failed to report image uid #{id}: #{exception.message}"
  csv << ['', id, '', '', '']
end

def add_solr_document(csv: csv, document: document, id: id)
  height, width = dimensions(document)
  csv << [
    document.uid,
    id,
    document.pref_label,
    height,
    width,
    document.fetch('publish_channels_ssim', []).first,
    InboundRelationships.new(document.id).preferred_representation_id
  ]
end

def dimensions(document)
  intermediate_id = document.fetch('intermediate_ids_ssim', []).first
  return 0, 0 unless intermediate_id
  intermediate_asset = ActiveFedora::SolrService.query("id:#{intermediate_id}").first
  height = intermediate_asset.fetch('height_is', 0)
  width = intermediate_asset.fetch('width_is', 0)
  [height, width]
end

def csv_columns
  [
    "uid",
    "imaging_uid",
    "title",
    "master_height",
    "master_width",
    "publish_channels",
    "preferred_representation"
  ]
end

ActiveFedora::SolrService.reset!
ActiveFedora::SolrService.register(url: solr_connection)

CSV.open(output_file, "wb") do |csv|
  csv << csv_columns
  imaging_uids.map { |id| add_assets(csv: csv, id: id) }
end
