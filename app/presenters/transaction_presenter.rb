# frozen_string_literal: true
class TransactionPresenter < Sufia::WorkShowPresenter
  def self.terms
    CitiResourceTerms.all
  end

  include CitiPresenterBehaviors

  def deleteable?
    current_ability.can?(:delete, Transaction)
  end
end
