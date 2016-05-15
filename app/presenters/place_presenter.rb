# frozen_string_literal: true
class PlacePresenter
  include Hydra::Presenter
  include RelatedAssetTerms

  def self.model_terms
    [
      :location_type,
      :lat,
      :long
    ]
  end

  self.model_class = Place
  self.terms = model_terms + CitiResourceTerms.all

  def summary_terms
    [:uid, :name_official, :created_by, :resource_created, :resource_updated]
  end
end
