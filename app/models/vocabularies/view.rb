class View < BaseVocabulary
  def self.query
    List.where(pref_label: "View")
  end
end
