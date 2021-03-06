# frozen_string_literal: true
class ShipmentPresenter < Sufia::WorkShowPresenter
  def self.terms
    CitiResourceTerms.all
  end

  include CitiPresenterBehaviors
  include ResourcePresenterBehaviors
end
