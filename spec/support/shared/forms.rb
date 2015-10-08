shared_examples "a form for a Citi resource" do

  describe ".model_attributes" do
    let(:params) { ActionController::Parameters.new( document_ids: [""] ) }
    subject { described_class.model_attributes(params) }

    it "removes empty strings" do
      expect(subject["document_ids"]).to be_empty
    end
  end

end
