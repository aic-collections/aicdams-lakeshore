class ExhibitionPresenter
  include Hydra::Presenter
  include RelatedAssetTerms
  include CitiStatus

  self.model_class = Exhibition
  self.terms = [
    :start_date,
    :end_date,
    :name_official,
    :name_working,
    :type_uid
  ] + CitiResourceTerms.all

end
