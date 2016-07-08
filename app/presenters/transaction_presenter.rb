# frozen_string_literal: true
class TransactionPresenter < Sufia::WorkShowPresenter
  def self.terms
    CitiResourceTerms.all
  end

  delegate(*terms, to: :solr_document)

  def title
    [pref_label]
  end

  def deleteable?
    current_ability.can?(:delete, Transaction)
  end
end
