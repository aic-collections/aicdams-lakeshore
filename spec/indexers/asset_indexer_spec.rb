# frozen_string_literal: true
require 'rails_helper'

describe AssetIndexer do
  describe "#generate_solr_document" do
    let(:asset)      { create(:department_asset, :with_metadata) }
    let(:solr_doc)   { described_class.new(asset).generate_solr_document }

    it "indexes the correct fields" do
      expect(solr_doc["digitization_source_tesim"]).to eq(asset.digitization_source.pref_label)
      expect(solr_doc["compositing_tesim"]).to eq(asset.compositing.pref_label)
      expect(solr_doc["light_type_tesim"]).to eq(asset.light_type.pref_label)
      expect(solr_doc["status_tesim"]).to eq(asset.status.pref_label)
      expect(solr_doc["aic_depositor_ssim"]).to eq(asset.aic_depositor.nick)
      expect(solr_doc["dept_created_tesim"]).to eq(asset.dept_created.pref_label)
      expect(solr_doc["aic_type_sim"]).to contain_exactly("Asset", "Still Image")
      expect(solr_doc["dept_created_sim"]).to eq(asset.dept_created.pref_label)
      expect(solr_doc["dept_created_citi_uid_ssim"]).to eq(asset.dept_created.citi_uid)
      expect(solr_doc["depositor_full_name_tesim"]).to contain_exactly("First User")
      expect(solr_doc["created_dtsi"]).to eq("2016-10-30T00:00:00Z")
      expect(solr_doc["updated_dtsi"]).to eq("2016-10-31T00:00:00Z")
      expect(solr_doc["public_domain_bsi"]).to be(false)
      expect(solr_doc["publishable_bsi"]).to be(false)
    end

    context "with all three document types" do
      it "builds a facet list with three types" do
        expect(solr_doc["document_types_sim"]).to contain_exactly("Event Photography", "Imaging", "Lecture")
      end
      it "builds a display field with three types" do
        expect(solr_doc["document_types_tesim"]).to eq("Imaging > Event Photography > Lecture")
      end
    end

    context "with one document type" do
      let(:asset) { build(:asset, id: "1234", document_type: AICDocType.AdMaterial) }
      it "builds a facet list with one type" do
        expect(solr_doc["document_types_sim"]).to contain_exactly("Ad Material")
      end
      it "builds a display field with one type" do
        expect(solr_doc["document_types_tesim"]).to eq("Ad Material")
      end
    end

    context "with two document types" do
      let(:asset) { build(:asset, id: "1234", document_type: AICDocType.AdMaterial, first_document_sub_type: AICDocType.MembershipEvent) }
      it "builds a facet list with two types" do
        expect(solr_doc["document_types_sim"]).to contain_exactly("Ad Material", "Membership event")
      end
      it "builds a display field with two types" do
        expect(solr_doc["document_types_tesim"]).to eq("Ad Material > Membership event")
      end
    end

    context "with no relationships" do
      it "creates a facet for assets without relationships" do
        expect(solr_doc["representation_sim"]).to eq("No Relationship")
      end
    end

    context "when the asset is an attachment of another asset" do
      let(:attachment) { build(:asset, id: "attachment-id") }

      before { allow(asset).to receive(:attachment_of).and_return([attachment]) }

      it "indexes the attachment_of relationship" do
        expect(solr_doc["attachment_of_ssim"]).to contain_exactly(attachment.id)
      end
    end

    context "with relationships" do
      let(:non_asset) { build(:non_asset, id: "non-asset") }

      before do
        allow(asset).to receive(:representation_of).and_return([non_asset])
        allow(asset).to receive(:preferred_representation_of).and_return([non_asset])
        allow(asset).to receive(:document_of).and_return([non_asset])
      end

      it "indexes each of the relationship types" do
        expect(solr_doc["representation_of_ssim"]).to contain_exactly(non_asset.id)
        expect(solr_doc["preferred_representation_of_ssim"]).to contain_exactly(non_asset.id)
        expect(solr_doc["document_of_ssim"]).to contain_exactly(non_asset.id)
      end
    end

    context "with fields from AssetSolrFieldBuilder" do
      let(:mock_builder) { double("AssetSolrFieldBuilder", representations: ["Is Attachment"],
                                                           related_works: ["work1"],
                                                           main_ref_numbers: ["1", "2"],
                                                           has_attachment_ids: ["attachment-1", "attachment-2"]) }

      before { allow(AssetSolrFieldBuilder).to receive(:new).with(asset).and_return(mock_builder) }

      it "indexes relationships, related works and main_ref_numbers " do
        expect(solr_doc[Solrizer.solr_name("representation", :facetable)]).to contain_exactly("Is Attachment")
        expect(solr_doc[Solrizer.solr_name("related_works", :symbol)]).to contain_exactly("work1")
        expect(solr_doc[Solrizer.solr_name("related_work_main_ref_number", :symbol)]).to contain_exactly("1", "2")
      end

      it "indexes the ids of the asset's attachments" do
        expect(solr_doc[Solrizer.solr_name("attachments", :symbol)]).to contain_exactly("attachment-1", "attachment-2")
      end
    end
  end
end
