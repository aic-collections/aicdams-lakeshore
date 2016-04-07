class DigitizationSource < BaseVocabulary
  def self.query
    List.find_by_label("Digitization Source")
  end
end
