class TransactionPresenter
  include Hydra::Presenter
  include RelatedAssetTerms

  self.model_class = Transaction
  self.terms = CitiResourceTerms.all

end
