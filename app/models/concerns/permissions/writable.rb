# frozen_string_literal: true
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
