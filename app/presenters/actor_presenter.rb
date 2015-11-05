class ActorPresenter
  include Hydra::Presenter
  include RelatedAssetTerms
  include CitiStatus

  self.model_class = Actor
  self.terms = [
    :birth_date,
    :birth_year,
    :actor_type,
    :death_date,
    :death_year
  ] + CitiResourceTerms.all

end
