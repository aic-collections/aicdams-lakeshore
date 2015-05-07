module Validations
  extend ActiveSupport::Concern
  
  def write_once_only_fields
    [:batch_uid, :aiccreated, :department, :legacy_uid].each do |property|
      self.errors.add property, 'is writable only on create' if self.send(property.to_s+"_changed?")
    end
  end

  def uid_matches_id
    return if self.uid == self.id
    self.uid = self.id
    self.save
  end

end
