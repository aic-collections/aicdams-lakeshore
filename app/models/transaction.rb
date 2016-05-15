# frozen_string_literal: true
class Transaction < CitiResource
  include ::CurationConcerns::WorkBehavior
  include CitiBehaviors

  def self.aic_type
    super << AICType.Transaction
  end

  type type + aic_type

  # TODO: Use has_many relation?
  property :exhibition, predicate: AIC.exhibition, class_name: "Exhibition"
end
