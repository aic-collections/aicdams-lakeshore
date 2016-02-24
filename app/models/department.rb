class Department < ListItem
  include CitiResourceMetadata

  PREFIX = "citi-".freeze

  def self.options(hash = {})
    all.map { |d| hash[d.pref_label] = d.department_key }
    hash
  end

  def self.find_by_department_key(key)
    where(citi_uid: key.delete(PREFIX)).first
  end

  def department_key
    PREFIX + citi_uid
  end
end
