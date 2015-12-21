class Compositing < BaseVocabulary
  def self.query
    List.where(pref_label: "Compositing")
  end
end
