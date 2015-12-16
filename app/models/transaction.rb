class Transaction < CitiResource
  include CitiBehaviors

  def self.aic_type
    super << AICType.Transaction
  end

  type aic_type
end
