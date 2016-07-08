# frozen_string_literal: true
require 'rails_helper'

describe ExhibitionPresenter do
  let(:exhibition) { build(:exhibition, id: '1234') }
  let(:ability)    { Ability.new(nil) }

  subject { described_class.new(exhibition.to_solr, ability) }

  it { is_expected.to delegate_method(:uid).to(:solr_document) }
  it { is_expected.not_to be_deleteable }
end
