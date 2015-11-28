require 'rails_helper'

describe "GenericFile" do

  let(:user) { FactoryGirl.find_or_create(:jill) }

  let(:department_file) do
    GenericFile.create.tap do |f|
      f.apply_depositor_metadata(user)
      f.assert_still_image
      f.visibility = LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT
    end
  end

  let(:registered_file) do
    GenericFile.create.tap do |f|
      f.apply_depositor_metadata(user)
      f.assert_still_image
      f.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED
    end
  end

  subject { GenericFile.new }

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

  describe "visibility" do
    context "by default" do
      its(:visibility) { is_expected.to eq(LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT)}
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
      its(:read_groups) { is_expected.to contain_exactly(LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT, "accounting") }
      its(:visibility) { is_expected.to eq(LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT) }
    end
  end

end
