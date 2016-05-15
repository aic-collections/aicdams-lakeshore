# frozen_string_literal: true
module Permissions
  module Readable
    extend ActiveSupport::Concern

    def department?
      !registered?
    end

    # Private visibility is disabled. Overrides CurationConcerns::Permissions::Readable
    def private?
      false
    end

    # Public visibility is disabled. Overrides CurationConcerns::Permissions::Readable
    def public?
      false
    end
  end
end
