# frozen_string_literal: true
class ConservationImageType < BaseVocabulary
  def self.query
    List.find_by_label("Conservation Image Type")
  end
end
