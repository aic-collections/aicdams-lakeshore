# A specific kind of ListItem that is only a member of the Status list
class StatusType < ListItem
  type [AICType.Resource, AICType.ListItem, AICType.StatusType]

  property :identifier, predicate: ::RDF::DC.identifier, multiple: false do |index|
    index.type :integer
  end

  def self.active
    find_by_label("Active")
  end

  def self.options
    options = {}
    StatusType.all.map { |t| options[t.pref_label] = t.id }
    options.sort.to_h
  end
end
