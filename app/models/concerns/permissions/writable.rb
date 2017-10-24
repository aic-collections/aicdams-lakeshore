# frozen_string_literal: true
# Use this module when we want to ensure that no resource will write any of its own ACLs to Fedora.
# This is used specifically with non-assets, such as {CitiResource} which use their own set of
# default permissions and do not need ACLs of their own.
module Permissions
  module Writable
    extend ActiveSupport::Concern

    included do
      # Use a default read-only ACL
      def access_control
        AccessControl.new
      end

      # Don't create any ACLs
      def create_access_control
        nil
      end
    end

    class AccessControl < Hydra::AccessControl
      private

        def create_or_update(*_args)
          true
        end
    end
  end
end
