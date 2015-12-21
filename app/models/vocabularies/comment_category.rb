class CommentCategory < BaseVocabulary
  def self.query
    List.where(pref_label: "Comment Category")
  end
end
