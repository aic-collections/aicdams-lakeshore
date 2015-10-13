require 'rails_helper'

describe "records/show_fields/_status.html.erb" do

  let(:asset_with_list_item) do
    stub_model(GenericFile, id: 'abc',
      status: [ListItem.new(AICStatus.active)]
    )
  end

  let(:mock_presenter) { double("record", status: [{"id"=>"http://definitions.artic.edu/ontology/1.0/status/active"}] ) }

  let(:result) { '<a href="http://definitions.artic.edu/ontology/1.0/status/active">http://definitions.artic.edu/ontology/1.0/status/active</a>' }

  before { allow(controller).to receive(:current_user).and_return(stub_model(User)) }
  subject { rendered }

  context "with a ListItem for status" do
    before { render partial: "records/show_fields/status.html.erb", locals: { record: AssetPresenter.new(asset_with_list_item) } }
    it { is_expected.to match(result) }
  end

  context "with a Hash for status" do
    before { render partial: "records/show_fields/status.html.erb", locals: { record: mock_presenter } }
    it { is_expected.to match(result) }
  end

end
