# frozen_string_literal: true
require 'rails_helper'

describe Resource do
  describe "RDF type" do
    subject { described_class.new.type.first }
    it { is_expected.to eql(AICType.Resource) }
  end

  it { is_expected.to respond_to(:batch_uid) }
  it { is_expected.to respond_to(:citi_icon) }
  it { is_expected.to respond_to(:contributors) }
  it { is_expected.to respond_to(:created) }
  it { is_expected.to respond_to(:created_by) }
  it { is_expected.to respond_to(:icon) }
  it { is_expected.to respond_to(:status) }
  it { is_expected.to respond_to(:status_uri) }
  it { is_expected.to respond_to(:updated) }
  it { is_expected.to respond_to(:language) }
  it { is_expected.to respond_to(:publisher) }
  it { is_expected.to respond_to(:rights) }
  it { is_expected.to respond_to(:rights_statement) }
  it { is_expected.to respond_to(:rights_holder) }
  it { is_expected.to respond_to(:alt_label) }
  it { is_expected.to respond_to(:citi_icon_uri=) }
  it { is_expected.to respond_to(:created_by_uri=) }
  it { is_expected.to respond_to(:icon_uri=) }
  it { is_expected.to respond_to(:contributor_uris=) }
  it { is_expected.to respond_to(:publisher_uris=) }
  it { is_expected.to respond_to(:rights_statement_uris=) }
  it { is_expected.to respond_to(:rights_holder_uris=) }
  it { is_expected.to respond_to(:citi_icon_uri) }
  it { is_expected.to respond_to(:created_by_uri) }
  it { is_expected.to respond_to(:icon_uri) }
  it { is_expected.to respond_to(:contributor_uris) }
  it { is_expected.to respond_to(:publisher_uris) }
  it { is_expected.to respond_to(:rights_statement_uris) }
  it { is_expected.to respond_to(:rights_holder_uris) }

  describe "cardinality" do
    [:batch_uid, :citi_icon, :created, :created_by, :icon, :status, :uid, :updated, :pref_label].each do |term|
      it "limits #{term} to a single value" do
        expect(described_class.properties[term.to_s].multiple?).to be false
      end
    end
  end

  describe "#status" do
    before { allow(ListItem).to receive(:active_status).and_return("active") }

    context "when active" do
      subject { described_class.new(status: "active") }
      it { is_expected.to be_active }
    end

    context "when nil" do
      subject { described_class.new(status: "inactive") }
      it { is_expected.not_to be_active }
    end
  end
end
