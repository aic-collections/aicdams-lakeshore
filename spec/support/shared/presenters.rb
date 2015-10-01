shared_examples "a presenter with terms for a Citi resource" do
  describe "::terms" do
    specify { expect(described_class.terms).to include(*CitiResourceTerms.all) }
  end
end

shared_examples "a presenter with related assets" do
  
  let(:presenter) { described_class.new(described_class.model_class.new) }
  let(:sample_asset) { mock_model(GenericFile) }

  describe "#documents" do
    before { allow_any_instance_of(described_class.model_class).to receive(:documents).and_return([sample_asset]) }
    specify { expect(presenter.documents).to contain_exactly(sample_asset) }
  end

  describe "#representations" do
    before { allow_any_instance_of(described_class.model_class).to receive(:representations).and_return([sample_asset]) }
    specify { expect(presenter.representations).to contain_exactly(sample_asset) }
  end

  describe "#preferred_representations" do
    before { allow_any_instance_of(described_class.model_class).to receive(:preferred_representations).and_return([sample_asset]) }
    specify { expect(presenter.preferred_representations).to contain_exactly(sample_asset) }
  end

end
