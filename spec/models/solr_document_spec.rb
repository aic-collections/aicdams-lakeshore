# frozen_string_literal: true
require 'rails_helper'

describe SolrDocument do
  describe "methods from Permissions::Readable" do
    context "by default" do
      its(:public?) { is_expected.to be false }
      its(:private?) { is_expected.to be false }
      its(:department?) { is_expected.to be true }
    end
    context "when registered" do
      before { subject["read_access_group_ssim"] = ["registered"] }
      its(:department?) { is_expected.to be false }
      its(:registered?) { is_expected.to be true }
    end
  end

  describe "#uid" do
    before { subject[Solrizer.solr_name("uid", :symbol)] = "UID" }
    its(:uid) { is_expected.to eq("UID") }
  end

  describe "#main_ref_number" do
    before { subject[Solrizer.solr_name("main_ref_number", :stored_searchable)] = "Main ref number" }
    its(:main_ref_number) { is_expected.to eq("Main ref number") }
  end

  describe "#visibility" do
    subject { described_class.new(asset.to_solr).visibility }
    context "with department assets" do
      let(:asset) { build(:department_asset) }
      it { is_expected.to eq("department") }
    end
    context "with registered assets" do
      let(:asset) { build(:registered_asset) }
      it { is_expected.to eq("authenticated") }
    end
    context "by default" do
      let(:asset) { build(:asset) }
      it { is_expected.to eq("department") }
    end
  end
end
