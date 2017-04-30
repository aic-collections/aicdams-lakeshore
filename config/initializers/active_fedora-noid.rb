# frozen_string_literal: true
require 'active_fedora/noid'

# Set ActiveFedora::Noid to use our custom uuid minter.
ActiveFedora::Noid.configure do |config|
  config.minter_class = UuidMinter
end
