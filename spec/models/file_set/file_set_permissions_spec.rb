# frozen_string_literal: true
require 'rails_helper'

describe FileSet do
  let(:file_set) { build(:file_set) }
  let(:asset) { nil }

  before do
    if asset.present?
      file_set.access_control_id = asset.access_control_id
      file_set.save
      asset.ordered_members = [file_set]
      asset.save
    end
  end

  context "without a containing asset" do
    specify do
      expect(file_set).not_to be_private
      expect(file_set).to be_department
      expect(file_set.visibility).to eq(Permissions::LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT)
      expect(file_set.read_groups).to be_empty
      expect(file_set.edit_groups).to contain_exactly("100", Permissions::LakeshoreVisibility::PERMISSION_TEXT_VALUE_DEPARTMENT)
      expect(file_set.discover_groups).to contain_exactly(Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_AUTHENTICATED)
    end
  end

  context "in a department asset" do
    let(:asset) { build(:department_asset) }

    specify do
      expect(file_set).not_to be_private
      expect(file_set).to be_department
      expect(file_set.visibility).to eq(Permissions::LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT)
      expect(file_set.read_groups).to be_empty
      expect(file_set.edit_groups).to contain_exactly("100", Permissions::LakeshoreVisibility::PERMISSION_TEXT_VALUE_DEPARTMENT)
      expect(file_set.discover_groups).to contain_exactly(Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_AUTHENTICATED)
    end
  end

  context "in a registered asset" do
    let(:asset) { build(:registered_asset) }

    specify do
      expect(file_set).not_to be_private
      expect(file_set).to be_registered
      expect(file_set.visibility).to eq(Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED)
      expect(file_set.read_groups).to contain_exactly(Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_AUTHENTICATED)
      expect(file_set.edit_groups).to contain_exactly("100")
      expect(file_set.discover_groups).to contain_exactly(Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_AUTHENTICATED)
    end
  end

  context "in a public asset" do
    let(:asset) { build(:public_asset) }

    specify do
      expect(file_set).not_to be_private
      expect(file_set).to be_public
      expect(file_set.visibility).to eq(Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC)
      expect(file_set.read_groups).to contain_exactly(Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_PUBLIC)
      expect(file_set.edit_groups).to contain_exactly("100")
      expect(file_set.discover_groups).to contain_exactly(Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_AUTHENTICATED)
    end
  end

  context "when changing the asset's permissions" do
    let(:asset) { build(:registered_asset) }

    before do
      asset.read_groups += ["custom_read_group"]
      asset.read_users += ["custom_read_user"]
      asset.edit_groups += ["custom_edit_group"]
      asset.edit_users += ["custom_edit_user"]
      asset.visibility = Permissions::LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT
      asset.save
    end

    it "retains the same ACL" do
      expect(file_set.access_control_id).to eq(asset.access_control_id)
      expect(file_set.read_groups).to contain_exactly("custom_read_group")
      expect(file_set.read_users).to contain_exactly("custom_read_user")
      expect(file_set.edit_groups).to contain_exactly("100",
                                                      Permissions::LakeshoreVisibility::PERMISSION_TEXT_VALUE_DEPARTMENT,
                                                      "custom_edit_group")
      expect(file_set.edit_users).to contain_exactly("custom_edit_user", "user1")
      expect(file_set.visibility).to eq(Permissions::LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT)
    end
  end

  describe "#apply_depositor_metadata" do
    subject { file_set }
    its(:depositor) { is_expected.to eq("user1") }
    its(:aic_depositor) { is_expected.to be_kind_of(AICUser) }
    its(:dept_created) { is_expected.to be_kind_of(Department) }
    describe "#to_solr" do
      subject { file_set.to_solr }
      it { is_expected.to include("aic_depositor_ssim" => "user1") }
    end
  end
end
