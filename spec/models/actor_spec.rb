require 'rails_helper'

describe Actor do

  describe "RDF type" do
    subject { described_class.new.type }
    it { is_expected.to contain_exactly(AICType.Actor, AICType.Resource, AICType.CitiResource) }
  end

  describe "terms" do
    subject { described_class.new }
    ActorPresenter.terms.each do |term|
      it { is_expected.to respond_to(term) }
    end
  end

  describe "#to_solr" do
    subject { described_class.new.to_solr }
    it "has default public read access" do
      expect(subject["read_access_group_ssim"]).to include("public")
    end
    it "has an AIC type" do
      expect(subject["aic_type_sim"]).to include("Actor")
    end
  end

  describe "visibility" do
    specify { expect(described_class.visibility).to eql "open" }
  end

  describe "featureability" do
    specify { expect(described_class.new).not_to be_featureable }
  end

  describe "permissions" do
    subject { described_class.new } 
    it { is_expected.to be_public }
    it { is_expected.not_to be_registered }
  end

  context "with CITI resources" do
    before { load_fedora_fixture(fedora_fixture("actor.ttl")) }
    it "indexes them into solr" do
      expect(Actor.all.count).to eql 1
    end
  end
end
