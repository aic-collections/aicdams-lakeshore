class DocumentType < BaseVocabulary
  def self.query
    List.find_by_label("Document Type")
  end
end
