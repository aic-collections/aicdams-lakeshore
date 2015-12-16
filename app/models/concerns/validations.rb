module Validations
  extend ActiveSupport::Concern

  # TODO: More information needed before we can implement these validations (see #100)
  included do
    # validate :write_once_only_fields, on: :update
  end

  def write_once_only_fields
    [:batch_uid, :resource_created, :dept_created, :legacy_uid].each do |property|
      errors.add property, 'is writable only on create' if send(property.to_s + "_changed?")
    end
  end
end
