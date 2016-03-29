class StatusType < ListItem
  type [AICType.Resource, AICType.ListItem, AICType.StatusType]

  property :identifier, predicate: ::RDF::DC.identifier, multiple: false do |index|
    index.type :integer
  end

  def self.invalid
    where(pref_label: "Invalid").first
  end

  def self.disabled
    where(pref_label: "Disabled").first
  end

  def self.deleted
    where(pref_label: "Deleted").first
  end

  def self.active
    where(pref_label: "Active").first
  end

  def self.archived
    where(pref_label: "Archived").first
  end

  def self.options
    options = {}
    StatusType.all.map { |t| options[t.pref_label] = t.id }
    options.sort.to_h
  end
end
