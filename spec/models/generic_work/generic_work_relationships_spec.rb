# frozen_string_literal: true
require 'rails_helper'

describe GenericWork do
  let(:user)  { create(:user1) }
  let(:asset) { build(:still_image_asset) }
  let(:attachment) { create(:asset) }
  let(:non_asset) { create(:non_asset) }
  let(:solr_document) { SolrDocument.find(non_asset.id) }

  context "without any relationships" do
    subject { asset }
    describe "#asset_has_relationships?" do
      it { is_expected.not_to be_asset_has_relationships }
    end
  end

  describe "#attachment_of" do
    let(:solr_document) { SolrDocument.find(attachment.id) }
    context "when adding" do
      before do
        asset.attachment_of_uris = [attachment.uri]
      end

      it "adds the attachment" do
        expect(asset.asset_has_relationships?).to be(true)
        expect(asset.attachment_of).to contain_exactly(attachment)
        asset.save
        expect(solr_document.attachment_ids).to include(asset.id)
      end
    end

    context "when removing" do
      before do
        asset.attachment_of_uris = [attachment.uri]
        asset.save
        asset.attachment_of_uris = []
      end

      it "removes the attachment" do
        asset.save
        expect(asset.asset_has_relationships?).to be(false)
        expect(asset.attachment_of).to be_empty
        expect(solr_document.attachment_ids).to be_empty
      end
    end
  end

  describe "#document_of" do
    context "when adding" do
      before do
        asset.document_of_uris = [non_asset.uri]
      end

      it "adds the document" do
        expect(asset.asset_has_relationships?).to be(true)
        expect(asset.document_of).to contain_exactly(non_asset)
        asset.save
        expect(solr_document.document_ids).to include(asset.id)
      end
    end

    context "when removing" do
      before do
        asset.document_of_uris = [non_asset.uri]
        asset.save
        asset.document_of_uris = []
      end

      it "removes the document" do
        asset.save
        expect(asset.asset_has_relationships?).to be(false)
        expect(asset.document_of).to be_empty
        expect(solr_document.document_ids).to be_empty
      end
    end
  end

  describe "#representation_of" do
    context "when adding" do
      before do
        asset.representation_of_uris = [non_asset.uri]
      end

      it "adds the representation" do
        expect(asset.asset_has_relationships?).to be(true)
        expect(asset.representation_of).to contain_exactly(non_asset)
        asset.save
        expect(solr_document.representation_ids).to include(asset.id)
      end
    end

    context "when removing" do
      before do
        asset.representation_of_uris = [non_asset.uri]
        asset.save
        asset.representation_of_uris = []
      end

      it "removes the representation" do
        asset.save
        expect(asset.asset_has_relationships?).to be(false)
        expect(asset.representation_of).to be_empty
        expect(solr_document.representation_ids).to be_empty
      end
    end
  end

  describe "#preferred_representation_of" do
    context "when adding" do
      before do
        asset.preferred_representation_of_uris = [non_asset.uri]
      end

      it "adds the preferred_representation" do
        expect(asset.asset_has_relationships?).to be(true)
        expect(asset.preferred_representation_of).to contain_exactly(non_asset)
        asset.save
        expect(solr_document.preferred_representation_id).to eq(asset.id)
      end
    end

    context "when removing" do
      before do
        asset.preferred_representation_of_uris = [non_asset.uri]
        asset.save
        asset.preferred_representation_of_uris = []
      end

      it "removes the preferred_representation" do
        asset.save
        expect(asset.asset_has_relationships?).to be(false)
        expect(asset.preferred_representation_of).to be_empty
        expect(solr_document.preferred_representation_id).to be_nil
      end
    end
  end
end
