# frozen_string_literal: true
require 'rails_helper'

describe "Facets" do
  # Moved from citi_resource_spec:
  # describe "assigning representations" do
  #   let(:resource)                   { SampleCitiResource.new }
  #   let(:asset)                      { create(:asset) }
  #   let(:solr_representations)       { asset.to_solr[Solrizer.solr_name("representation", :facetable)] }
  #   let(:facets_for_representations) { facets_for(Solrizer.solr_name("representation", :facetable), asset.id) }

  #   before do
  #     resource.representations = [asset.uri]
  #     resource.preferred_representation = asset.uri
  #     resource.documents = [asset.uri]
  #     resource.save
  #   end
  #   it "contains the correct kind of representations" do
  #     expect(resource.representations).to include(asset)
  #     expect(resource.preferred_representation).to eq(asset)
  #     expect(resource.documents).to include(asset)
  #     expect(solr_representations).to contain_exactly("Documentation For", "Is Representation", "Is Preferred Representation")
  #     expect(facets_for_representations).to contain_exactly("Documentation For", 1, "Is Representation", 1, "Is Preferred Representation", 1)
  #   end
  #   context "when removing the representation from the resource" do
  #     before do
  #       resource.representations = []
  #       resource.save
  #     end
  #     it "retains the preferred representation" do
  #       expect(resource.representations).to be_empty
  #       expect(resource.preferred_representation).to eq(asset)
  #       expect(solr_representations).to contain_exactly("Documentation For", "Is Preferred Representation")
  #       expect(facets_for_representations).to contain_exactly("Documentation For", 1, "Is Preferred Representation", 1)
  #     end
  #   end

  #   context "when reloading as a solr document" do
  #     subject { SolrDocument.new(resource.to_solr, nil) }
  #     its(:preferred_representation_id) { is_expected.to eq(asset.id) }
  #   end
  # end
end
