# frozen_string_literal: true
class PlacePresenter < Sufia::WorkShowPresenter
  def self.terms
    [
      :location_type,
      :lat,
      :long
    ] + CitiResourceTerms.all
  end

  delegate(*terms, to: :solr_document)

  def title
    [pref_label]
  end

  def deleteable?
    current_ability.can?(:delete, Place)
  end
end
