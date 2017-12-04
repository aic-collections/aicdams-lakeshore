# frozen_string_literal: true
require 'rails_helper'

describe CitiBehaviors do
  before(:all) do
    class SampleCitiResource < CitiResource
      include ::CurationConcerns::WorkBehavior
      include CitiBehaviors
    end
  end

  after(:all) do
    Object.send(:remove_const, :SampleCitiResource) if defined?(SampleCitiResource)
  end

  subject { SampleCitiResource.new }

  describe "Hydra ACLs" do
    before { SampleCitiResource.create(pref_label: "Sample CITI Resource") }
    specify "are not created for the resource" do
      expect(Permissions::Writable::AccessControl.all.count).to eq(0)
    end
  end

  describe "#to_solr" do
    let(:solr_doc) { subject.to_solr }
    it "has default public read access" do
      expect(solr_doc["read_access_group_ssim"]).to contain_exactly("group", "registered")
    end
    it "has an AIC type" do
      expect(solr_doc["aic_type_sim"]).to include("SampleCitiResource")
    end
    it "has a status" do
      expect(solr_doc[Solrizer.solr_name("status", :symbol)]).to eq(["Active"])
    end
  end

  describe "visibility" do
    specify { expect(SampleCitiResource.visibility).to eql "authenticated" }
  end

  describe "permissions" do
    it { is_expected.not_to be_department }
    it { is_expected.to be_registered }
  end

  describe "#edit_groups" do
    its(:edit_groups) { is_expected.to include("registered") }
  end

  describe "featureability" do
    specify { expect(SampleCitiResource.new).not_to be_featureable }
  end
end
