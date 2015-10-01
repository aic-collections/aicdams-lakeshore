require 'rails_helper'

describe WorkPresenter do
  it_behaves_like "a presenter with terms for a Citi resource"
  it_behaves_like "a presenter with related assets"

  let(:presenter) { described_class.new(described_class.model_class.new) }
  let(:sample_asset) { mock_model(GenericFile) }

  describe "#assets" do
    before { allow_any_instance_of(Work).to receive(:assets).and_return([sample_asset]) }
    specify { expect(presenter.assets).to contain_exactly(sample_asset) }
  end
end
