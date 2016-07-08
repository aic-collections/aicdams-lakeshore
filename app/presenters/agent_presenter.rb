# frozen_string_literal: true
class AgentPresenter < Sufia::WorkShowPresenter
  include RelatedAssetTerms

  def self.terms
    [
      :birth_date,
      :birth_year,
      :agent_type,
      :death_date,
      :death_year
    ] + CitiResourceTerms.all
  end

  delegate(*terms, to: :solr_document)

  def title
    [pref_label]
  end

  def summary_terms
    [:uid, :created_by, :resource_created, :resource_updated]
  end

  def deleteable?
    current_ability.can?(:delete, Agent)
  end
end
