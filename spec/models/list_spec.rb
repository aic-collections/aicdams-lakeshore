require 'rails_helper'

describe List do
  describe "status lists" do
    describe "active" do
      subject { StatusType.active }
      its(:pref_label) { is_expected.to eq("Active") }
    end
  end

  context "when creating duplicated items in a new list" do
    let(:list) { create(:list) }
    before do
      list.add_item(ListItem.new(pref_label: "Used"))
      list.add_item(ListItem.new(pref_label: "Used"))
    end
    it "does not add the duplicate member" do
      expect(list.errors.full_messages).to contain_exactly("Members must be unique")
      expect(list.members.map(&:pref_label)).to contain_exactly("Used", "Item 1")
    end
  end

  describe "permissions" do
    subject { described_class.new }
    it { is_expected.to respond_to(:edit_users) }
    it { is_expected.to respond_to(:read_users) }
    it { is_expected.to respond_to(:edit_groups) }
    it { is_expected.to respond_to(:read_groups) }
  end
end
