# frozen_string_literal: true
class Transaction < CitiResource
  include ::CurationConcerns::WorkBehavior
  include CitiBehaviors

  def self.aic_type
    super << AICType.Transaction
  end

  type type + aic_type

  # @todo This does not work as written and is likely not currently being used
  property :exhibition, predicate: AIC.exhibition, class_name: "Exhibition"
end
