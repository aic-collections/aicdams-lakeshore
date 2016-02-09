namespace :lakeshore do

  # Parse a ttl file for the ldp:contains predicate and submit an UpdateIndexJob for each uri listed
  desc "Reindex all resources in Fedora using a ttl file"
  task :reindex, [:file] => :environment do |task, args|
  	puts "Parsing #{args.file} ..."
  	contains = File.open(args.file).map { |line| line if line =~ /ldp\:contains/ }
  	contains.compact.first.split(/\s+/).find_all { |u| u.match(/<(.*)>/) }.each do |pid|
      Sufia.queue.push(UpdateIndexJob.new(pid.split(/\//).last.chop))
  	end
  end

end
