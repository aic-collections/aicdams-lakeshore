module LakeshorePermissions
  extend ActiveSupport::Concern

  def department?
    !registered?
  end

  # Private visibility is disabled. Overrides Sufia::Permissions::Readable
  def private?
    false
  end

  # Public visibility is disabled. Overrides Sufia::Permissions::Readable
  def public?
    false
  end
end
