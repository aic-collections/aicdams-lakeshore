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
    it "has a status" do
      expect(solr_doc[Solrizer.solr_name("status", :symbol)]).to eq(["Active"])
    end
  end

  describe "visibility" do
    specify { expect(described_class.visibility).to eql "authenticated" }
  end

  describe "permissions" do
    it { is_expected.not_to be_department }
    it { is_expected.to be_registered }
  end

  describe "status" do
    subject { described_class.all.first.status }
    its(:pref_label) { is_expected.to eq("Active") }
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

shared_examples "a vocabulary term" do
  describe "::all" do
    subject { described_class.all }
    its(:first) { is_expected.to be_kind_of(ListItem) }
  end

  describe "::options" do
    subject { described_class.options }
    its(:keys) { is_expected.to contain_exactly("Item 1") }
  end
end
