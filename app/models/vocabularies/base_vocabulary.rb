class BaseVocabulary
  def self.all
    return [] unless query
    query.members
  end

  def self.options
    options = {}
    all.map { |t| options[t.pref_label] = t.id }
    options.sort.to_h
  end
end
