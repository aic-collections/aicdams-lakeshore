module ListLoader
  def load_lists
    ListManager.new("config/lists/status.yml").create!
    department
  end

  def department
    raise "Department type list already exists!" unless Department.all.empty?
    list = List.new(pref_label: "Department")
    list.members = [
      Department.new(pref_label: "Department 100", citi_uid: "100"),
      Department.new(pref_label: "Department 200", citi_uid: "200")
    ]
    list.save
  end
end
