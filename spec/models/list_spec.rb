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

end
