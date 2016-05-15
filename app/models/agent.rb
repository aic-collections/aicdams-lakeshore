# frozen_string_literal: true
class Agent < CitiResource
  include ::CurationConcerns::WorkBehavior
  include CitiBehaviors

  def self.aic_type
    super + [AICType.Agent, ::RDF::Vocab::FOAF.Agent]
  end

  type type + aic_type

  property :birth_date, predicate: AIC.birthDate do |index|
    index.type :date
    index.as :stored_searchable
  end

  property :birth_year, predicate: AIC.birthYear do |index|
    index.type :integer
    index.as :stored_searchable
  end

  # TODO: I think this is a list
  property :agent_type, predicate: AIC.agentType, multiple: false, class_name: "ActiveFedora::Base"

  property :death_date, predicate: AIC.deathDate do |index|
    index.type :date
    index.as :stored_searchable
  end

  property :death_year, predicate: AIC.deathYear do |index|
    index.type :integer
    index.as :stored_searchable
  end
end
