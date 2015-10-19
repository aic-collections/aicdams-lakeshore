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

end
