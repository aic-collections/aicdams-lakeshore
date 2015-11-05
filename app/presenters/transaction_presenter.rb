class TransactionPresenter
  include Hydra::Presenter
  include RelatedAssetTerms
  include CitiStatus

  self.model_class = Transaction
  self.terms = CitiResourceTerms.all

end
