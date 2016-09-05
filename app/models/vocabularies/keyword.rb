# frozen_string_literal: true
class Keyword < BaseVocabulary
  def self.query
    List.find_by_label("Keyword")
  end
end
