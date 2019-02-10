# frozen_string_literal: true
class AddEditGroupPermissionJob < ActiveJob::Base
  queue_as :release

  class Error < StandardError; end

  def perform(id:, group:)
    raise Error, "Department id #{group} does not exist" unless Department.find_by_citi_uid(group)
    asset = GenericWork.find(id)
    edit_groups = asset.edit_groups
    return if edit_groups.include?(group)
    new_groups = edit_groups + [group]
    asset.edit_groups = new_groups
    asset.save
    asset.file_sets.map(&:update_index)
  end
end
