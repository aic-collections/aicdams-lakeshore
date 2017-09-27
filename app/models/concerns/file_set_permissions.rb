# frozen_string_literal: true
# Defines permissions behaviors for file sets using existing modules that are present in other classes.
# File sets do not use their own ACLs, and instead use the ACL of its parent asset. All methods
# related to permissions are delegated to #parent. If it is not present, a default set of permissions
# is returned.
module FileSetPermissions
  extend ActiveSupport::Concern

  include Permissions::WithAICDepositor
  include Permissions::LakeshoreVisibility
  include Permissions::Readable
  include Permissions::Writable

  # Override CurationConcerns::Permissions
  # This avoids the "Depositor must have edit access" error message.
  def paranoid_permissions
    true
  end

  def visibility
    return Permissions::LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT unless parent.present?
    parent.visibility
  end

  def discover_users
    return [] unless parent.present?
    parent.discover_users
  end

  def discover_groups
    return [Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_AUTHENTICATED] unless parent.present?
    parent.discover_groups
  end

  def read_users
    return [] unless parent.present?
    parent.read_users
  end

  def read_groups
    return [] unless parent.present?
    parent.read_groups
  end

  def edit_users
    return [depositor] unless parent.present?
    parent.edit_users
  end

  def edit_groups
    return [dept_created.citi_uid, Permissions::LakeshoreVisibility::PERMISSION_TEXT_VALUE_DEPARTMENT] unless parent.present?
    parent.edit_groups
  end
end
