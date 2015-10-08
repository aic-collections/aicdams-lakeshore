shared_examples "a model for a Citi resource" do

  describe "#to_solr" do
    subject { described_class.new.to_solr }
    it "has default public read access" do
      expect(subject["read_access_group_ssim"]).to include("public")
    end
    it "has an AIC type" do
      expect(subject["aic_type_sim"]).to include(described_class.to_s)
    end
  end

  describe "visibility" do
    specify { expect(described_class.visibility).to eql "open" }
  end

  describe "permissions" do
    subject { described_class.new } 
    it { is_expected.to be_public }
    it { is_expected.not_to be_registered }
  end

  context "with CITI resources" do
    before { load_fedora_fixture(fedora_fixture("#{described_class.to_s.downcase}.ttl")) }
    it "indexes them into solr" do
      expect(described_class.all.count).to eql 1
    end
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
