class Status < BaseVocabulary
  def self.query
    List.find_by_label("Status")
  end
end
