require 'resque/pool/tasks'

# This provides access to the Rails env within all Resque workers
task 'resque:setup' => :environment

# Set up resque-pool
task 'resque:pool:setup' do
  Resque::Pool.after_prefork do |job|
    Resque.redis.client.reconnect
  end
end
