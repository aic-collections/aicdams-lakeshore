# frozen_string_literal: true
module Permissions
  extend ActiveSupport::Concern

  include Readable
  include LakeshoreVisibility
  include WithAICDepositor

  included do
    validate :public_cannot_read

    # TODO: Move to module if other classes require this
    def public_cannot_read
      errors[:read_users] = "Public cannot have read access" if read_groups.include?("public")
    end
  end
end
