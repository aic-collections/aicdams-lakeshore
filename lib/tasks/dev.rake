desc "Run continuous integration test"
task ci: ['jetty:clean', 'db:migrate'] do
  jetty_params = Jettywrapper.load_config
  error = Jettywrapper.wrap(jetty_params) do
    Rake::Task['spec'].invoke
  end
  raise "test failures: #{error}" if error
end

namespace :jetty do

  desc "Configure Jetty"
  task config: ['jetty:clean', 'sufia:jetty:config', 'jetty:start', 'fedora:config']

end

namespace :fedora do
  desc "Register namespace prefixes in Fedora"
  task :config do
    puts "Registering namespace prefixes in Fedora"
    system("script/fedora_config.sh")
  end
end
