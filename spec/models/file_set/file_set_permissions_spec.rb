# frozen_string_literal: true
require 'rails_helper'

describe FileSet do
  let(:department_asset) { build(:file_set) }
  let(:registered_asset) { build(:registered_file) }
  let(:public_asset)     { build(:public_file) }

  context "with a department asset" do
    subject { department_asset }
    it { is_expected.not_to be_private }
    it { is_expected.to be_department }
    its(:visibility) { is_expected.to eq(Permissions::LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT) }
    its(:read_groups) { is_expected.to be_empty }
    its(:edit_groups) { is_expected.to contain_exactly("100", Permissions::LakeshoreVisibility::PERMISSION_TEXT_VALUE_DEPARTMENT) }
    its(:discover_groups) { is_expected.to contain_exactly(Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_AUTHENTICATED) }
  end

  context "with a registered asset" do
    subject { registered_asset }
    it { is_expected.not_to be_private }
    it { is_expected.to be_registered }
    its(:visibility) { is_expected.to eq(Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED) }
    its(:read_groups) { is_expected.to contain_exactly(Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_AUTHENTICATED) }
    its(:edit_groups) { is_expected.to contain_exactly("100") }
    its(:discover_groups) { is_expected.to contain_exactly(Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_AUTHENTICATED) }
  end

  context "with a public asset" do
    subject { public_asset }
    it { is_expected.not_to be_private }
    it { is_expected.to be_public }
    its(:visibility) { is_expected.to eq(Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC) }
    its(:read_groups) { is_expected.to contain_exactly(Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_PUBLIC) }
    its(:edit_groups) { is_expected.to contain_exactly("100") }
    its(:discover_groups) { is_expected.to contain_exactly(Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_AUTHENTICATED) }
  end

  context "when changing from department to restricted" do
    subject { department_asset }
    before { subject.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE }
    specify { expect(subject.errors.messages[:visibility]).to include("cannot be restricted") }
  end

  context "when changing from department to registered" do
    subject { department_asset }
    before { department_asset.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED }
    its(:read_groups) { is_expected.to contain_exactly(Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_AUTHENTICATED) }
    its(:edit_groups) { is_expected.to contain_exactly("100") }
    its(:visibility) { is_expected.to eq(Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED) }
  end

  context "when changing from department to public" do
    subject { department_asset }
    before { department_asset.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC }
    its(:read_groups) { is_expected.to contain_exactly(Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_PUBLIC) }
    its(:edit_groups) { is_expected.to contain_exactly("100") }
    its(:visibility) { is_expected.to eq(Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC) }
  end

  context "when changing from registered to department" do
    subject { registered_asset }
    before { registered_asset.visibility = Permissions::LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT }
    its(:read_groups) { is_expected.to be_empty }
    its(:edit_groups) { is_expected.to contain_exactly("100", Permissions::LakeshoreVisibility::PERMISSION_TEXT_VALUE_DEPARTMENT) }
    its(:visibility) { is_expected.to eq(Permissions::LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT) }
  end

  context "when changing from registered to public" do
    subject { registered_asset }
    before { registered_asset.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC }
    its(:read_groups) { is_expected.to contain_exactly(Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_PUBLIC) }
    its(:edit_groups) { is_expected.to contain_exactly("100") }
    its(:visibility) { is_expected.to eq(Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC) }
  end

  context "when changing from public to registered" do
    subject { public_asset }
    before { public_asset.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED }
    its(:read_groups) { is_expected.to contain_exactly(Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_AUTHENTICATED) }
    its(:edit_groups) { is_expected.to contain_exactly("100") }
    its(:visibility) { is_expected.to eq(Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED) }
  end

  context "when changing from public to department" do
    subject { public_asset }
    before { public_asset.visibility = Permissions::LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT }
    its(:read_groups) { is_expected.to be_empty }
    its(:edit_groups) { is_expected.to contain_exactly("100", Permissions::LakeshoreVisibility::PERMISSION_TEXT_VALUE_DEPARTMENT) }
    its(:visibility) { is_expected.to eq(Permissions::LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT) }
  end

  context "when changing a registered asset with custom permissions to department" do
    subject { registered_asset }
    before do
      registered_asset.read_groups += ["custom_read_group"]
      registered_asset.read_users += ["custom_read_user"]
      registered_asset.edit_groups += ["custom_edit_group"]
      registered_asset.edit_users += ["custom_edit_user"]
      registered_asset.visibility = Permissions::LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT
    end
    its(:read_groups) { is_expected.to contain_exactly("custom_read_group") }
    its(:read_users) { is_expected.to contain_exactly("custom_read_user") }
    its(:edit_groups) { is_expected.to contain_exactly("100",
                                                       Permissions::LakeshoreVisibility::PERMISSION_TEXT_VALUE_DEPARTMENT,
                                                       "custom_edit_group") }
    its(:edit_users) { is_expected.to contain_exactly("custom_edit_user", "user1") }
    its(:visibility) { is_expected.to eq(Permissions::LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT) }
  end

  context "when changing a public asset with custom permissions to department" do
    subject { public_asset }
    before do
      public_asset.read_groups += ["custom_read_group"]
      public_asset.read_users += ["custom_read_user"]
      public_asset.edit_groups += ["custom_edit_group"]
      public_asset.edit_users += ["custom_edit_user"]
      public_asset.visibility = Permissions::LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT
    end
    its(:read_groups) { is_expected.to contain_exactly("custom_read_group") }
    its(:read_users) { is_expected.to contain_exactly("custom_read_user") }
    its(:edit_groups) { is_expected.to contain_exactly("100",
                                                       Permissions::LakeshoreVisibility::PERMISSION_TEXT_VALUE_DEPARTMENT,
                                                       "custom_edit_group") }
    its(:edit_users) { is_expected.to contain_exactly("custom_edit_user", "user1") }
    its(:visibility) { is_expected.to eq(Permissions::LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT) }
  end

  context "when changing a department asset with custom permissions to registered" do
    subject { department_asset }
    before do
      department_asset.read_groups += ["custom_read_group"]
      department_asset.read_users += ["custom_read_user"]
      department_asset.edit_groups += ["custom_edit_group"]
      department_asset.edit_users += ["custom_edit_user"]
      department_asset.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED
    end
    its(:read_groups) { is_expected.to contain_exactly("custom_read_group",
                                                       Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_AUTHENTICATED) }
    its(:read_users) { is_expected.to contain_exactly("custom_read_user") }
    its(:edit_groups) { is_expected.to contain_exactly("100", "custom_edit_group") }
    its(:edit_users) { is_expected.to contain_exactly("custom_edit_user", "user1") }
    its(:visibility) { is_expected.to eq(Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED) }
  end

  context "when changing a department asset with custom permissions to public" do
    subject { department_asset }
    before do
      department_asset.read_groups += ["custom_read_group"]
      department_asset.read_users += ["custom_read_user"]
      department_asset.edit_groups += ["custom_edit_group"]
      department_asset.edit_users += ["custom_edit_user"]
      department_asset.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    end
    its(:read_groups) { is_expected.to contain_exactly("custom_read_group",
                                                       Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_PUBLIC) }
    its(:read_users) { is_expected.to contain_exactly("custom_read_user") }
    its(:edit_groups) { is_expected.to contain_exactly("100", "custom_edit_group") }
    its(:edit_users) { is_expected.to contain_exactly("custom_edit_user", "user1") }
    its(:visibility) { is_expected.to eq(Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC) }
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
      subject { build(:file_set, user: "nobody") }
      its(:save) { is_expected.to be false }
    end
  end
end
