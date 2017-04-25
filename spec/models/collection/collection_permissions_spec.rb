# frozen_string_literal: true
require 'rails_helper'

describe Collection do
  let(:department_asset) { build(:department_collection) }
  let(:registered_asset) { build(:registered_collection) }

  context "by default" do
    it { is_expected.to be_private }
    its(:discover_groups) { is_expected.to contain_exactly(Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_AUTHENTICATED) }
    its(:visibility) { is_expected.to eq("restricted") }
  end

  context "when setting to private" do
    before { subject.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE }
    it { is_expected.to be_private }
  end

  context "when setting to department" do
    before { subject.visibility = Permissions::LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT }
    its(:visibility) { is_expected.to eq("department") }
    it { is_expected.to be_department }
  end

  context "when setting to open" do
    before { subject.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC }
    its(:read_groups) { is_expected.to include("public") }
  end

  context "when changing from department to registered" do
    subject { department_asset }
    before { department_asset.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED }
    its(:read_groups) { is_expected.to contain_exactly(Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_AUTHENTICATED) }
    its(:visibility) { is_expected.to eq(Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED) }
  end

  context "when changing from registered to department" do
    subject { registered_asset }
    before { registered_asset.visibility = Permissions::LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT }
    its(:read_groups) { is_expected.to contain_exactly(Permissions::LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT, "100") }
    its(:visibility) { is_expected.to eq(Permissions::LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT) }
  end

  describe "#apply_depositor_metadata" do
    context "with an AIC depositor" do
      subject { registered_asset }
      its(:depositor) { is_expected.to eq("user1") }
      its(:aic_depositor) { is_expected.to be_kind_of(AICUser) }
      its(:dept_created) { is_expected.to be_kind_of(Department) }
      describe "#to_solr" do
        subject { registered_asset.to_solr }
        it { is_expected.to include("aic_depositor_ssim" => "user1") }
      end
    end

    context "without an AIC depositor" do
      subject { build(:asset, user: "nobody") }
      its(:save) { is_expected.to be false }
    end
  end
end
