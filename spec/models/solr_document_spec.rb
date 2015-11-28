require 'rails_helper'

describe SolrDocument do

  describe "#title_or_label" do
    before { subject[Solrizer.solr_name("pref_label", :stored_searchable)] = "work label" }
    its(:title_or_label) { is_expected.to eq("work label") }
  end

  describe "#title" do
    context "when absent" do
      before { subject[Solrizer.solr_name("pref_label", :stored_searchable)] = "work label" }
      its(:title) { is_expected.to eq("work label") }
    end
    context "when present" do
      before { subject[Solrizer.solr_name("title", :stored_searchable)] = "work title" }
      its(:title) { is_expected.to eq("work title") }
    end
  end

  describe "visibility" do
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

end
