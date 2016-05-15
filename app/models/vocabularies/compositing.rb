# frozen_string_literal: true
class Compositing < BaseVocabulary
  def self.query
    List.find_by_label("Compositing")
  end
end
