class DigitizationSource < BaseVocabulary
  def self.query
    List.where(pref_label: "Digitization Source")
  end
end
