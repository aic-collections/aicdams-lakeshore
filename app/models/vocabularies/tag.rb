# frozen_string_literal: true
class Tag < BaseVocabulary
  def self.query
    List.find_by_label("Tag")
  end
end
