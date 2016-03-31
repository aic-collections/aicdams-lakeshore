require 'rails_helper'

describe CitiResourcePresenter do
  subject { described_class.new(resource) }

  context "when the resource is nil" do
    let(:resource) { nil }
    its(:display_name) { is_expected.to be_nil }
  end

  describe "an AICUser" do
    context "with all fields" do
      let(:resource) { build(:aic_user) }
      its(:display_name) { is_expected.to eq("Joe Bob (joebob)") }
    end
    context "without a last name" do
      let(:resource) { build(:aic_user, family_name: nil) }
      its(:display_name) { is_expected.to eq("Joe (joebob)") }
    end
    context "without a first name" do
      let(:resource) { build(:aic_user, given_name: nil) }
      its(:display_name) { is_expected.to eq("Bob (joebob)") }
    end
    context "with only a nick" do
      let(:resource) { build(:aic_user, given_name: nil, family_name: nil) }
      its(:display_name) { is_expected.to eq("(joebob)") }
    end
  end

  describe "any other resource" do
    context "with a pref_label" do
      let(:resource) { double("Resource", pref_label: "A label") }
      its(:display_name) { is_expected.to eq("A label") }
    end

    context "without a pref_label" do
      let(:resource) { double }
      its(:display_name) { is_expected.to be_nil }
    end
  end
end
