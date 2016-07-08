# frozen_string_literal: true
class ExhibitionPresenter < Sufia::WorkShowPresenter
  def self.terms
    [
      :start_date,
      :end_date,
      :name_official,
      :name_working,
      :exhibition_type
    ] + CitiResourceTerms.all
  end

  delegate(*terms, to: :solr_document)

  def title
    [pref_label]
  end

  def deleteable?
    current_ability.can?(:delete, Exhibition)
  end

  def summary_terms
    [:uid, :name_official, :created_by, :resource_created, :resource_updated]
  end
end
