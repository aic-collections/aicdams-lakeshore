# Although technically not true Hydra or Sufia permissions, these are some basic methods
# that allow Works to behave with other objects that do have permissions.
module WorkPermissions

  def public?
    true
  end

  def registered?
    false
  end

end
