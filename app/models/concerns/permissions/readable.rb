# frozen_string_literal: true
# Included module that overrides and extends aspects of CurationConcerns::Permissions::Readable.
# Provides convenience methods for checking a class's visibility.
module Permissions
  module Readable
    extend ActiveSupport::Concern

    def department?
      visibility == 'department'
    end

    # Only collections can be private.
    def private?
      return false unless is_a?(Collection)
      !(public? || registered? || department?)
    end
  end
end
