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

shared_examples "a vocabulary term" do |first_label|
  describe "::all" do
    subject { described_class.all }
    its(:first) { is_expected.to be_kind_of(ListItem) }
  end

  describe "::options" do
    subject { described_class.options }
    its(:keys) { is_expected.to contain_exactly(first_label) }
  end
end

shared_examples "a vocabulary term restricted to single values" do |term|
  let(:resource) { described_class.new }
  let(:vocab) { term.to_s.classify.constantize.all.first }
  context "with a ListItem object" do
    before { resource.send("#{term}=", vocab) }
    subject { resource.send(term) }
    its(:pref_label) { is_expected.to eq("Sample #{term.to_s.titleize} List Item") }
  end
  context "with an id" do
    before { resource.send("#{term}_id=", vocab.id) }
    subject { resource.send(term) }
    its(:pref_label) { is_expected.to eq("Sample #{term.to_s.titleize} List Item") }
    context "when removing" do
      before { resource.send("#{term}_id=", nil) }
      it { is_expected.to be_nil }
    end
  end
end

shared_examples "a vocabulary term that accepts multiple values" do |term|
  let(:resource) { described_class.new }
  if term == "category"
    let(:vocab) { CommentCategory.all.first }
    let(:label) { "Sample Comment Category List Item" }
  else
    let(:vocab) { term.to_s.classify.constantize.all.first }
    let(:label) { "Sample #{term.to_s.titleize} List Item" }
  end
  context "with a ListItem object" do
    before { resource.send("#{term}=", [vocab]) }
    subject { resource.send(term).first }
    its(:pref_label) { is_expected.to eq(label) }
  end
  context "with an id" do
    before { resource.send("#{term}_ids=", [vocab.id]) }
    subject { resource.send(term).first }
    its(:pref_label) { is_expected.to eq(label) }
  end
end
