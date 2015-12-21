class BaseVocabulary
  def self.all
    return [] if query.empty?
    query.first.members
  end

  def self.options
    options = {}
    all.map { |t| options[t.pref_label] = t.id }
    options
  end
end
