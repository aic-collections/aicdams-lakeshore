require 'rails_helper'

describe "records/show_fields/_status.html.erb" do
  let(:asset) do
    stub_model(GenericFile, id: 'abc', status: StatusType.active)
  end

  before { allow(controller).to receive(:current_user).and_return(stub_model(User)) }
  subject { rendered }

  context "with a StatusType for status" do
    before { render partial: "records/show_fields/status.html.erb", locals: { record: AssetPresenter.new(asset) } }
    it { is_expected.to match("Active") }
  end
end
