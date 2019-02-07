# Reads in csv file and updates permissions
# @example To update all the assets in a csv granting department 246 edit access:
#   bundle exec rails runner script/update-permissions.rb file.csv 246

def options
  @options ||= OpenStruct.new
end

ARGV.options do |opts|
  opts.on("-c", "--check", "Checks if asset exists with the correct permissions") { |val| options.check = true }
  opts.on("-g", "--group=", "REQUIRED: CITI department id", String) { |val| options.group = val }
  opts.on("-e", "--environment=", String) { |val| options.group = val }

  opts.on_tail("-h", "--help") do
    puts opts
    exit
  end

  opts.parse!
end

unless options.group
  puts "CITI department id is required"
  exit(1)
end

unless Department.find_by_citi_uid(options.group)
  puts "Department id #{options.group} does not exist"
  exit(1)
end

unless ARGV[0]
  puts "CSV file is required"
  exit(1)
end

script = UpdatePermissionsScript.new(csv_file: ARGV[0], group: options.group)

if options.check
  puts script.check
else
  script.run
end
