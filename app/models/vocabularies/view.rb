# frozen_string_literal: true
class View < BaseVocabulary
  def self.query
    List.find_by_label("View")
  end
end
