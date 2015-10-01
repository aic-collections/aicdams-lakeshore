require 'rails_helper'

describe Work do

  describe "intial RDF types" do
    subject { described_class.new.type }
    it { is_expected.to contain_exactly(AICType.Work, AICType.CitiResource, AICType.Resource) }
  end

  describe "metadata" do
    subject { described_class.new }
    context "defined in the presenter" do
      WorkPresenter.terms.each do |term|
        it { is_expected.to respond_to(term) }
      end
    end
  end

  describe "#to_solr" do
    subject { described_class.new.to_solr }
    it "has default public read access" do
      expect(subject["read_access_group_ssim"]).to include("public")
    end
    it "has an AIC type" do
      expect(subject["aic_type_sim"]).to include("Work")
    end
  end

  describe "visibility" do
    specify { expect(described_class.visibility).to eql "open" }
  end

  describe "featureability" do
    specify { expect(described_class.new).to be_featureable }
  end

  describe "permissions" do
    subject { described_class.new } 
    it { is_expected.to be_public }
    it { is_expected.not_to be_registered }
  end

  context "with CITI resources" do
    before { load_fedora_fixture(fedora_fixture("work.ttl")) }
    it "indexes them into solr" do
      expect(Work.all.count).to eql 1
    end
  end

end
