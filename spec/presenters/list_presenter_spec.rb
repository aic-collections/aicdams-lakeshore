require 'rails_helper'

describe ListPresenter do
  subject { described_class.new(List.where(pref_label: "Status").first) }

  describe "#to_s" do
    its(:to_s) { is_expected.to eq("Status") }
  end

  describe "#member_list" do
    let(:active) { ["Active", "Record is available for use.", StatusType.active.id] }
    its(:member_list) { is_expected.to include(active) }
    context "when an item as no description" do
      before { allow_any_instance_of(ListItem).to receive(:description).and_return([]) }
      let(:no_desription) { ["Active", "No description available", StatusType.active.id] }
      its(:member_list) { is_expected.to include(no_desription) }
    end
  end
end
