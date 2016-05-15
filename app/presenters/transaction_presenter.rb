# frozen_string_literal: true
class TransactionPresenter
  include Hydra::Presenter
  include RelatedAssetTerms

  self.model_class = Transaction
  self.terms = [:exhibition] + CitiResourceTerms.all

  def summary_terms
    [:uid, :created_by, :resource_created, :resource_updated]
  end
end
