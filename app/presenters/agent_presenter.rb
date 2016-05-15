# frozen_string_literal: true
class AgentPresenter
  include Hydra::Presenter
  include RelatedAssetTerms

  self.model_class = Agent
  self.terms = [
    :birth_date,
    :birth_year,
    :agent_type,
    :death_date,
    :death_year
  ] + CitiResourceTerms.all

  def summary_terms
    [:uid, :created_by, :resource_created, :resource_updated]
  end
end
