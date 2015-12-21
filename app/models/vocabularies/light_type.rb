class LightType < BaseVocabulary
  def self.query
    List.where(pref_label: "Light Type").map { |l| l if l.pref_label == "Light Type" }.compact
  end
end
