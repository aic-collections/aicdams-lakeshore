namespace :lakeshore do

  # Parse a ttl file for the ldp:contains predicate and submit an UpdateIndexJob for each uri listed
  desc "Reindex all resources in Fedora using a ttl file"
  task :reindex, [:file] => :environment do |task, args|
  	puts "Parsing #{args.file} ..."
  	contains = File.open(args.file).map { |line| line if line =~ /ldp\:contains/ }
  	contains.compact.first.split(/\s+/).find_all { |u| u.match(/<(.*)>/) }.each do |pid|
      UpdateIndexJob.perform_later(pid.split(/\//).last.chop)
  	end
  end

  desc "Reindex all resources using existing Solr index"
  task reindex_from_solr: :environment do
    start = 0
    total = Blacklight::Solr::Response.new(query, nil).total_count
    while (start < total) do
      response = Blacklight::Solr::Response.new(query(start), nil)
      response.docs.map { |d| UpdateIndexJob.perform_later(d.fetch("id")) }
      start = start + response.rows
    end
  end

  desc "Delete records in Solr that are not present in Fedora"
  task delete_from_solr: :environment do
    start = 0
    total = Blacklight::Solr::Response.new(query, nil).total_count
    while (start < total) do
      response = Blacklight::Solr::Response.new(query(start), nil)
      response.docs.map { |d| DeleteIndexJob.perform_later(d.fetch("id")) }
      start = start + response.rows
    end
  end

  desc "Load lists"
  task load_lists: :environment do
    # Delete all solr records for lists
    list_ids = ActiveFedora::SolrService.query("has_model_ssim:List", rows: 1000).map(&:id)
    list_item_ids = ActiveFedora::SolrService.query("has_model_ssim:ListItem", rows: 1000).map(&:id)
    [list_ids + list_item_ids].each { |id| ActiveFedora::SolrService.delete(id) }
    ActiveFedora::SolrService.commit

    Dir.glob("config/lists/*.yml").each do |list|
      ListManager.new(list).create
    end
  end

  desc "Re-index lists"
  task reindex_lists: :environment do
    ListItem.all.map(&:update_index)
    List.all.map(&:update_index)
  end

  desc "Regenerate derivatives for all assets"
  task regenerate: :environment do
    FileSet.all.each do |fs|
      RegenerateAssetDerivativesJob.perform_later(fs, fs.original_file.id)
    end
  end

  desc "Regenerate citi derivatives for all assets"
  task regenerate_citi_thumbnails: :environment do
    FileSet.all.each do |fs|
      RegenerateCitiDerivativesJob.perform_later(fs, fs.original_file.id)
    end
  end

  def query(start=0)
    Blacklight.default_index.connection.get('select', params: {
                                                                q: "*:*",
                                                                qt: "document",
                                                                fl: "id",
                                                                start: start,
                                                                rows: 1000
                                                              })
  end
end
