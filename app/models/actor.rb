class Actor < CitiResource

  def self.aic_type
    super << AICType.Actor
  end

  type aic_type

  property :birth_date, predicate: AIC.birthDate do |index|
    index.type :date
    index.as :stored_searchable
  end

  property :birth_year, predicate: AIC.birthYear do |index|
    index.type :integer
    index.as :stored_searchable
  end

  property :actor_type, predicate: AIC.actorType do |index|
    index.as :stored_searchable
  end

  property :death_date, predicate: AIC.deathDate do |index|
    index.type :date
    index.as :stored_searchable
  end

  property :death_year, predicate: AIC.deathYear do |index|
    index.type :integer
    index.as :stored_searchable
  end

end
