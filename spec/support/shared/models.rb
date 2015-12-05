shared_examples "a model for a Citi resource" do
  subject { described_class.all.first }

  describe "#to_solr" do
    let(:solr_doc) { subject.to_solr }
    it "has default public read access" do
      expect(solr_doc["read_access_group_ssim"]).to contain_exactly("group", "registered")
    end
    it "has an AIC type" do
      expect(solr_doc["aic_type_sim"]).to include(described_class.to_s)
    end
  end

  describe "visibility" do
    specify { expect(described_class.visibility).to eql "authenticated" }
  end

  describe "permissions" do
    it { is_expected.not_to be_department }
    it { is_expected.to be_registered }
  end
end

shared_examples "a featureable model" do
  describe "featureability" do
    specify { expect(described_class.new).to be_featureable }
  end
end

shared_examples "an unfeatureable model" do
  describe "featureability" do
    specify { expect(described_class.new).not_to be_featureable }
  end
end
