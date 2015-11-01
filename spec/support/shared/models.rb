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
    subject { described_class.all.first }
    it { is_expected.to be_kind_of(described_class) }

    it "defaults to active" do
      expect(subject.status.first.id).to eq(AICStatus.active.to_s)
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
