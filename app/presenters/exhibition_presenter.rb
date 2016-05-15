# frozen_string_literal: true
class ExhibitionPresenter
  include Hydra::Presenter
  include RelatedAssetTerms

  def self.model_terms
    [
      :start_date,
      :end_date,
      :name_official,
      :name_working,
      :exhibition_type
    ]
  end

  self.model_class = Exhibition
  self.terms = model_terms + CitiResourceTerms.all

  def summary_terms
    [:uid, :name_official, :created_by, :resource_created, :resource_updated]
  end
end
