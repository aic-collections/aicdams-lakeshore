# frozen_string_literal: true
require 'rails_helper'

describe AssetIndexer do
  describe "#generate_solr_document" do
    let(:attachment) { create(:asset) }
    let(:asset)      { create(:asset, :with_metadata, attachments: [attachment.uri]) }
    let(:solr_doc)   { described_class.new(asset).generate_solr_document }

    it "indexes the correct fields" do
      expect(solr_doc["digitization_source_tesim"]).to eq(asset.digitization_source.pref_label)
      expect(solr_doc["compositing_tesim"]).to eq(asset.compositing.pref_label)
      expect(solr_doc["light_type_tesim"]).to eq(asset.light_type.pref_label)
      expect(solr_doc["light_type_tesim"]).to eq(asset.light_type.pref_label)
      expect(solr_doc["status_tesim"]).to eq(asset.status.pref_label)
      expect(solr_doc["aic_depositor_ssim"]).to eq(asset.aic_depositor.nick)
      expect(solr_doc["dept_created_tesim"]).to eq(asset.dept_created.pref_label)
      expect(solr_doc["aic_type_sim"]).to contain_exactly("Asset", "Still Image")
      expect(solr_doc["dept_created_sim"]).to eq(asset.dept_created.pref_label)
      expect(solr_doc["attachments_ssim"]).to contain_exactly(attachment.id)
      expect(solr_doc["depositor_full_name_tesim"]).to contain_exactly("First User")
      expect(solr_doc["created_dtsi"]).to eq("2016-10-30T00:00:00Z")
      expect(solr_doc["updated_dtsi"]).to eq("2016-10-31T00:00:00Z")
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
      let(:asset) { build(:asset, document_type: AICDocType.AdMaterial) }
      it "builds a facet list with one type" do
        expect(solr_doc["document_types_sim"]).to contain_exactly("Ad Material")
      end
      it "builds a display field with one type" do
        expect(solr_doc["document_types_tesim"]).to eq("Ad Material")
      end
    end

    context "with two document types" do
      let(:asset) { build(:asset, document_type: AICDocType.AdMaterial, first_document_sub_type: AICDocType.MembershipEvent) }
      it "builds a facet list with two types" do
        expect(solr_doc["document_types_sim"]).to contain_exactly("Ad Material", "Membership event")
      end
      it "builds a display field with two types" do
        expect(solr_doc["document_types_tesim"]).to eq("Ad Material > Membership event")
      end
    end

    context "with no relationships" do
      let(:asset) { create(:asset, :with_metadata) }
      let(:solr_doc) { described_class.new(asset).generate_solr_document }
      it "creates a facet for assets without relationships" do
        expect(solr_doc["representation_sim"]).to eq("No Relationship")
      end
    end

    # Related_works is an array of hashes, in JSON.
    # The array contains hashes of representations data, each hash contains only citi_uids
    # and main_ref_numbers of a representation.
    describe "create related_works field" do
      context "with one relationship" do
        let!(:asset) { create(:asset) }
        let!(:work) { create(:work, :with_sample_metadata, representations: [asset.uri]) }
        let!(:solr_doc) { described_class.new(asset).generate_solr_document }
        it "creates fields for related works" do
          expect(solr_doc["related_works_ssim"]).to include_json([{ citi_uid: "43523", main_ref_number: "1999.397" }])
          expect(solr_doc["related_work_main_ref_number_ssim"]).to contain_exactly("1999.397")
        end
      end

      context "with two relationships" do
        let!(:asset) { create(:asset) }
        let!(:work) { create(:work, :with_sample_metadata, representations: [asset.uri]) }
        let!(:work2) { create(:work, :with_sample_metadata, citi_uid: "12345", main_ref_number: "2017.392", representations: [asset.uri]) }
        let!(:solr_doc) { described_class.new(asset).generate_solr_document }
        it "creates fields for related works" do
          expect(solr_doc["related_works_ssim"]).to include_json([{ citi_uid: "43523", main_ref_number: "1999.397" },
                                                                  { citi_uid: "12345", main_ref_number: "2017.392" }])
          expect(solr_doc["related_work_main_ref_number_ssim"]).to contain_exactly("1999.397", "2017.392")
        end
      end

      context "with missing work data" do
        let!(:asset) { create(:asset) }
        let!(:work) { create(:work, :with_sample_metadata, citi_uid: "", main_ref_number: "", representations: [asset.uri]) }
        let!(:solr_doc) { described_class.new(asset).generate_solr_document }
        it "won't create a list with empty values" do
          expect(solr_doc["related_works_ssim"]).to eq("[]")
          expect(solr_doc["related_work_main_ref_number_ssim"]).to be_empty
        end
      end

      # The related_works field does not distinguish preferred representations in any way,
      # they simply must be indexed if present.
      context "with a representation and a preferred representation of the same work" do
        let!(:asset) { create(:asset) }
        let!(:work) { create(:work, :with_sample_metadata, representations: [asset.uri], preferred_representation: asset.uri) }
        let!(:solr_doc) { described_class.new(asset).generate_solr_document }
        it "won't index duplicates" do
          expect(solr_doc["related_works_ssim"]).to include_json([{ citi_uid: "43523", main_ref_number: "1999.397" }])
          expect(solr_doc["related_work_main_ref_number_ssim"]).to contain_exactly("1999.397")
        end
      end

      context "with a preferred representation" do
        let!(:asset) { create(:asset) }
        let!(:preferred_representation) { create(:work, citi_uid: "12345", main_ref_number: "2017.392", preferred_representation: asset.uri) }
        let!(:solr_doc) { described_class.new(asset).generate_solr_document }
        it "will index the preferred representation" do
          expect(solr_doc["related_works_ssim"]).to include_json([{ citi_uid: "12345", main_ref_number: "2017.392" }])
          expect(solr_doc["related_work_main_ref_number_ssim"]).to contain_exactly("2017.392")
        end
      end

      context "with several preferred representations" do
        let!(:asset) { create(:asset) }
        let!(:preferred_representation1) { create(:work, citi_uid: "54321", main_ref_number: "1720.392", preferred_representation: asset.uri) }
        let!(:preferred_representation2) { create(:work, citi_uid: "12345", main_ref_number: "2017.392", preferred_representation: asset.uri) }
        let!(:solr_doc) { described_class.new(asset).generate_solr_document }
        it "will index the preferred representations" do
          expect(solr_doc["related_works_ssim"]).to include_json([{ citi_uid: "54321", main_ref_number: "1720.392" },
                                                                  { citi_uid: "12345", main_ref_number: "2017.392" }])
          expect(solr_doc["related_work_main_ref_number_ssim"]).to contain_exactly("1720.392", "2017.392")
        end
      end
    end
  end
end
