require 'rails_helper'

describe "records/show_fields/_status.html.erb" do

  let(:asset) do
    stub_model(GenericFile, id: 'abc', status: [StatusType.where(pref_label: "Active").first])
  end

  let(:list_item_presenter) do
    double("record", status: [UndefinedListItem.new(AICStatus.active)])
  end

  let(:hash_presenter) do
    double("record", status: [{"id"=>"http://definitions.artic.edu/ontology/1.0/status/active"}] )
  end

  let(:result) { '<a href="http://definitions.artic.edu/ontology/1.0/status/active">http://definitions.artic.edu/ontology/1.0/status/active</a>' }

  before { allow(controller).to receive(:current_user).and_return(stub_model(User)) }
  subject { rendered }

  context "with a StatusType for status" do
    before { render partial: "records/show_fields/status.html.erb", locals: { record: AssetPresenter.new(asset) } }
    it { is_expected.to match("Active") }
  end

  context "with an UndefinedListItem for status" do
    before { render partial: "records/show_fields/status.html.erb", locals: { record: list_item_presenter } }
    it { is_expected.to match(result) }
  end

  context "with a Hash for status" do
    before { render partial: "records/show_fields/status.html.erb", locals: { record: hash_presenter } }
    it { is_expected.to match(result) }
  end

end
