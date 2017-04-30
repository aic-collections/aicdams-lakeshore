# frozen_string_literal: true
# Custom minter class that uses the ActiveFedora::Noid gem as its template. The only significant change
# is the call to {next_id} which returns a uuid using Ruby's SecureRandom class.
#
# Instead of using a file or database to maintain state, no state is maintained at all.
# While Ruby's own method is strong enough to ensure that each uuid is unique, if the resulting
# uuid from {next_id} is in fact being used in Fedora, ActiveFedora::Noid::Minter::Base
# will simply call {next_id} again until a suitably unique one is returned.
#
# See https://github.com/projecthydra/active_fedora-noid for more documentation.
class UuidMinter < ActiveFedora::Noid::Minter::Base
  protected

    # @return [String] in uuid form such as 896fb041-841a-4eb2-988e-8c11bfb81772
    def next_id
      SecureRandom.uuid
    end
end
