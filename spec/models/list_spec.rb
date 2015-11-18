require 'rails_helper'

describe List do

  describe "status lists" do
    describe "invalid" do
      subject { StatusType.invalid }
      its(:pref_label) { is_expected.to eq("Invalid") }
    end
    describe "disabled" do
      subject { StatusType.disabled }
      its(:pref_label) { is_expected.to eq("Disabled") }
    end
    describe "deleted" do
      subject { StatusType.deleted }
      its(:pref_label) { is_expected.to eq("Deleted") }
    end
    describe "active" do
      subject { StatusType.active }
      its(:pref_label) { is_expected.to eq("Active") }
    end
    describe "archived" do
      subject { StatusType.archived }
      its(:pref_label) { is_expected.to eq("Archived") }
    end
  end

  context "when adding duplicate items" do
    let(:status_list) { List.where(pref_label: "Status").first }
    before do 
      status_list.members << StatusType.new(pref_label: "Active")
      status_list.save
    end
    subject { status_list.errors }
    its(:full_messages) { is_expected.to include("Members must be unique") }
  end

end
