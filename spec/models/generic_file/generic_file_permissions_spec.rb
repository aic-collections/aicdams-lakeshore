require 'rails_helper'

describe GenericFile do
  let(:department_file) { create(:department_file) }
  let(:registered_file) { create(:registered_file) }

  describe "default permissions" do
    it { is_expected.not_to be_private }
    it { is_expected.to be_department }
  end

  describe "#lakeshore_paranoid_edit_permissions" do
    before { subject.read_groups = ["public"] }
    specify "the public cannot have read access" do
      expect(subject.save).to be false
      expect(subject.errors.messages[:read_users]).to include("Public cannot have read access")
    end
  end

  describe "#admin_can_edit" do
    context "for new resources" do
      before { subject.save }
      its(:edit_groups) { is_expected.to include("admin") }
    end
    context "when the admin group is removed" do
      before do
        subject.save
        subject.edit_groups -= ["admin"]
        subject.save
      end
      its(:edit_groups) { is_expected.to include("admin") }
    end
  end

  describe "visibility" do
    context "by default" do
      its(:visibility) { is_expected.to eq(LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT) }
      its(:read_groups) { is_expected.to be_empty }
    end

    context "when setting to restricted" do
      before { subject.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE }
      specify { expect(subject.errors.messages[:visibility]).to include("cannot be restricted") }
    end

    context "when setting to open" do
      before { subject.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC }
      specify { expect(subject.errors.messages[:visibility]).to include("cannot be open") }
    end

    context "when changing from department to registered" do
      subject { department_file }
      before { department_file.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED }
      its(:read_groups) { is_expected.to contain_exactly(Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_AUTHENTICATED) }
      its(:visibility) { is_expected.to eq(Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED) }
    end

    context "when changing from registered to department" do
      subject { registered_file }
      before { registered_file.visibility = LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT }
      its(:read_groups) { is_expected.to contain_exactly(LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT, "100") }
      its(:visibility) { is_expected.to eq(LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT) }
    end
  end

  describe "#apply_depositor_metadata" do
    context "with an AIC depositor" do
      subject { registered_file }
      its(:depositor) { is_expected.to eq("user1") }
      its(:aic_depositor) { is_expected.to be_kind_of(AICUser) }
      its(:dept_created) { is_expected.to be_kind_of(Department) }
      describe "#to_solr" do
        subject { registered_file.to_solr }
        it { is_expected.to include("aic_depositor_ssim" => "user1") }
      end
    end

    context "without an AIC depositor" do
      subject { build(:asset, user: "nobody") }
      its(:save) { is_expected.to be false }
    end
  end
end
