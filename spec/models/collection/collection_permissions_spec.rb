# frozen_string_literal: true
require 'rails_helper'

describe Collection do
  subject { collection }

  context "with a private collection" do
    let(:collection) { build(:private_collection) }
    it { is_expected.to be_private }
    its(:discover_groups) { is_expected.to contain_exactly(Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_AUTHENTICATED) }
    its(:visibility) { is_expected.to eq(Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE) }
  end

  context "with a department collection" do
    let(:collection) { build(:department_collection) }
    its(:visibility) { is_expected.to eq(Permissions::LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT) }
    it { is_expected.to be_department }
  end

  context "with a registered collection" do
    let(:collection) { build(:registered_collection) }
    its(:visibility) { is_expected.to eq(Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED) }
    it { is_expected.to be_registered }
  end

  context "with a public collection" do
    let(:collection) { build(:public_collection) }
    its(:read_groups) { is_expected.to contain_exactly(Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_PUBLIC) }
  end

  context "when changing from department to registered" do
    let(:collection) { build(:department_collection) }
    before { collection.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED }
    its(:read_groups) { is_expected.to contain_exactly(Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_AUTHENTICATED) }
    its(:visibility) { is_expected.to eq(Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED) }
  end

  context "when changing from registered to department" do
    let(:collection) { build(:registered_collection) }
    before { collection.visibility = Permissions::LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT }
    its(:edit_groups) { is_expected.to contain_exactly(Permissions::LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT, "100") }
    its(:visibility) { is_expected.to eq(Permissions::LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT) }
  end

  describe "#apply_depositor_metadata" do
    context "with an AIC depositor" do
      let(:collection) { build(:registered_collection) }
      its(:depositor) { is_expected.to eq("user1") }
      its(:aic_depositor) { is_expected.to be_kind_of(AICUser) }
      its(:dept_created) { is_expected.to be_kind_of(Department) }
      describe "#to_solr" do
        subject { collection.to_solr }
        it { is_expected.to include("aic_depositor_ssim" => "user1") }
      end
    end

    context "without an AIC depositor" do
      subject { build(:collection, user: "nobody") }
      its(:save) { is_expected.to be false }
    end
  end
end
