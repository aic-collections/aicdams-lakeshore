class ActorPresenter < AbstractPresenter

  def self.terms
    [ 
      :birth_date,
      :birth_year,
      :actor_type,
      :death_date,
      :death_year
    ] + CitiResourcePresenter.terms
  end

end
