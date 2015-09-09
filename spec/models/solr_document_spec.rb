require 'rails_helper'

describe SolrDocument do

  describe "#title_or_label" do
    before { subject[Solrizer.solr_name("pref_label", :stored_searchable)] = "work label" }
    it "uses a work's pref_label" do
      expect(subject.title_or_label).to eq 'work label'
    end
  end

end
