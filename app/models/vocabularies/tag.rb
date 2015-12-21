class Tag < BaseVocabulary
  def self.query
    List.where(pref_label: "Tag")
  end
end
