# frozen_string_literal: true
require 'rails_helper'

describe ShipmentPresenter do
  let(:shipment) { build(:shipment, id: '1234') }
  let(:ability)    { Ability.new(nil) }

  subject { described_class.new(shipment.to_solr, ability) }

  it { is_expected.to delegate_method(:uid).to(:solr_document) }
  it { is_expected.not_to be_deleteable }
end
