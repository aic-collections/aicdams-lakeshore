require 'rails_helper'

describe "Resources that nest assets" do
  let(:resource) { described_class.new }
  let(:asset) { create(:asset) }
  let(:solr_representations) { asset.to_solr[Solrizer.solr_name("representation", :facetable)] }
  let(:facets_for_representations) { facets_for(Solrizer.solr_name("representation", :facetable), asset.id) }

  shared_examples "a resource that can nest assets" do
    before do
      resource.representation_ids = [asset.id]
      resource.preferred_representation_ids = [asset.id]
      resource.document_ids = [asset.id]
      resource.save
    end
    it "contains the correct kind of representations" do
      expect(resource.representations).to include(asset)
      expect(resource.preferred_representations).to include(asset)
      expect(resource.documents).to include(asset)
      expect(solr_representations).to contain_exactly("Is Document", "Is Representation", "Is Preferred Representation")
      expect(facets_for_representations).to contain_exactly("Is Document", 1, "Is Representation", 1, "Is Preferred Representation", 1)
    end
    context "when removing the representation from the resource" do
      before do
        resource.representation_ids = []
        resource.save
      end
      it "retains the preferred representation" do
        expect(resource.representations).to be_empty
        expect(resource.preferred_representations).to include(asset)
        expect(solr_representations).to contain_exactly("Is Document", "Is Preferred Representation")
        expect(facets_for_representations).to contain_exactly("Is Document", 1, "Is Preferred Representation", 1)
      end
    end
    context "when removing the asset" do
      before { asset.destroy }
      specify do
        expect(asset.errors).to include(:representations)
        expect(asset).to be_persisted
      end
    end
  end

  describe Work do
    it_behaves_like "a resource that can nest assets"

    describe "#assets" do
      before do
        resource.asset_ids = [asset.id]
        resource.save
      end
      specify { expect(resource.assets).to include(asset) }
      context "when removing the asset from the resource" do
        before { resource.asset_ids = [] }
        it "retains the asset" do
          expect(resource.assets).to be_empty
          expect(GenericFile.all).to include(asset)
        end
      end
      context "when deleting the asset" do
        before { asset.destroy }
        specify do
          expect(asset.errors).to include(:representations)
          expect(asset).to be_persisted
        end
      end
    end
  end

  describe Actor do
    it_behaves_like "a resource that can nest assets"
  end
end
