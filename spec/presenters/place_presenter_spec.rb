# frozen_string_literal: true
require 'rails_helper'

describe PlacePresenter do
  let(:place) { build(:place, id: '1234') }
  let(:ability) { Ability.new(nil) }

  subject { described_class.new(place.to_solr, ability) }

  it { is_expected.to delegate_method(:uid).to(:solr_document) }
  it { is_expected.not_to be_deleteable }
end
