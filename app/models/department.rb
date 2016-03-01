class Department < ListItem
  include CitiResourceMetadata

  PREFIX = "citi-".freeze

  class << self
    def options(hash = {})
      all.map { |d| hash[d.pref_label] = d.department_key }
      hash
    end

    def find_by_department_key(key)
      where("citi_uid_ssim" => key.delete(PREFIX)).first
    end
  end

  def department_key
    PREFIX + citi_uid
  end
end
