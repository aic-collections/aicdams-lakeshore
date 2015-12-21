class ConservationImageType < BaseVocabulary
  def self.query
    List.where(pref_label: "Conservation Image Type").map { |l| l if l.pref_label == "Conservation Image Type" }.compact
  end
end
