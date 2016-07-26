# frozen_string_literal: true
require 'rails_helper'

describe AssetIndexer do
  describe "#generate_solr_document" do
    let(:asset)    { create(:asset, :with_metadata) }
    let(:solr_doc) { described_class.new(asset).generate_solr_document }

    it "indexes the correct fields" do
      expect(solr_doc["document_type_ssim"]).to eq(asset.document_type.pref_label)
      expect(solr_doc["first_document_sub_type_ssim"]).to eq(asset.first_document_sub_type.pref_label)
      expect(solr_doc["second_document_sub_type_ssim"]).to eq(asset.second_document_sub_type.pref_label)
    end
  end
end
