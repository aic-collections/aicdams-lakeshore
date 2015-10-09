module Validations
  extend ActiveSupport::Concern

  # TODO: More information needed before we can implement these validations (see #100)
  included do
    # validate :write_once_only_fields, on: :update
    # after_save :uid_matches_id, on: :create
    before_save :status_is_active, on: :create
  end
  
  def write_once_only_fields
    [:batch_uid, :resource_created, :dept_created, :legacy_uid].each do |property|
      self.errors.add property, 'is writable only on create' if self.send(property.to_s+"_changed?")
    end
  end

  def uid_matches_id
    return if self.uid == self.id
    self.uid = self.id
    self.save
  end

  def status_is_active
    self.status = [ListItem.new(AICStatus.active)]
  end

end
