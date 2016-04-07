class LightType < BaseVocabulary
  def self.query
    List.find_by_label("Light Type")
  end
end
