# Load a yaml file where we've specified our admin users' emails
ADMINS = YAML::load(ERB.new(IO.read(File.join(Rails.root, 'config', 'admin.yml'))).result)[Rails.env]
