# frozen_string_literal: true
require 'rails_helper'

describe CitiResource do
  describe "RDF type" do
    subject { described_class.new.type }
    it { is_expected.to contain_exactly(AICType.Resource, AICType.CitiResource) }
  end

  it { is_expected.to delegate_method(:representations).to(:incomming_asset_reference) }
  it { is_expected.to delegate_method(:representation_uris).to(:incomming_asset_reference) }
  it { is_expected.to delegate_method(:preferred_representation).to(:incomming_asset_reference) }
  it { is_expected.to delegate_method(:preferred_representation_uri).to(:incomming_asset_reference) }
  it { is_expected.to delegate_method(:documents).to(:incomming_asset_reference) }
  it { is_expected.to delegate_method(:document_uris).to(:incomming_asset_reference) }

  describe "#status" do
    subject { described_class.new.status }
    it { is_expected.to eq(ListItem.active_status) }
  end

  describe "with events" do
    subject { described_class.new }
    its(:events) { is_expected.to be_empty }
  end
end
