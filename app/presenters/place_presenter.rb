# frozen_string_literal: true
class PlacePresenter < Sufia::WorkShowPresenter
  def self.terms
    [
      :location_type,
      :lat,
      :long
    ] + CitiResourceTerms.all
  end

  include CitiPresenterBehaviors

  def deleteable?
    current_ability.can?(:delete, Place)
  end
end
