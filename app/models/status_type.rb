class StatusType < ListItem

  type [AICType.Resource, AICType.ListItem, AICType.StatusType]

  property :identifier, predicate: ::RDF::DC.identifier, multiple: false do |index|
    index.type :integer
  end

  def self.invalid
    self.where(pref_label: "Invalid").first
  end

  def self.disabled
    self.where(pref_label: "Disabled").first
  end

  def self.deleted
    self.where(pref_label: "Deleted").first
  end

  def self.active
    self.where(pref_label: "Active").first
  end

  def self.archived
    self.where(pref_label: "Archived").first
  end

  def self.options
    options = {}
    StatusType.all.map { |t| options[t.pref_label] = t.id }
    options
  end
end
