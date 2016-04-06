require 'rails_helper'

describe ListManager do
  let(:manager) { described_class.new("yaml file") }

  before { allow(YAML).to receive(:load_file).and_return({}) }

  describe "#exists?" do
    subject { manager.exists? }
    context "when the list does not exist" do
      before { expect(List).to receive(:where).and_return([]) }
      it { is_expected.to be false }
    end
    context "when the list exists" do
      before { expect(List).to receive(:where).and_return(["a list"]) }
      it { is_expected.to be true }
    end
  end

  describe "#list_has?" do
    before { allow(manager).to receive(:list).and_return(list) }
    subject { manager.list_has?(member) }

    context "when adding a new member" do
      let(:list) { build(:list) }
      let(:member) { { "pref_label" => "new item" } }
      it { is_expected.to be false }
    end

    context "when adding an existing member" do
      let(:list) { create(:list, :with_items, items: ["existing item"]) }
      let(:member) { { "pref_label" => "existing item" } }
      it { is_expected.to be true }
    end
  end
end
