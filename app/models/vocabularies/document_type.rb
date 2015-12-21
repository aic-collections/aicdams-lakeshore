class DocumentType < BaseVocabulary
  def self.query
    List.where(pref_label: "Document Type").map { |l| l if l.pref_label == "Document Type" }.compact
  end
end
