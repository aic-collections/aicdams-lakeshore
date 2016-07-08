# frozen_string_literal: true
class ShipmentPresenter < Sufia::WorkShowPresenter
  def self.terms
    CitiResourceTerms.all
  end

  delegate(*terms, to: :solr_document)

  def title
    [pref_label]
  end

  def deleteable?
    current_ability.can?(:delete, Shipment)
  end
end
