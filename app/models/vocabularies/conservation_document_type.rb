class ConservationDocumentType < BaseVocabulary
  # TODO: Avoid fuzzy matches, see #217
  def self.query
    List.where(pref_label: "Conservation Document Type").map { |l| l if l.pref_label == "Conservation Document Type" }.compact
  end
end
