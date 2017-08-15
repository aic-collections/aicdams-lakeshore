# frozen_string_literal: true
require 'rails_helper'

describe CollectionIndexer do
  describe "#generate_solr_document" do
    let(:collection) { create(:collection, :with_metadata) }
    let(:solr_doc)   { described_class.new(collection).generate_solr_document }

    it "indexes the correct fields" do
      expect(solr_doc["aic_depositor_ssim"]).to eq(collection.aic_depositor.nick)
      expect(solr_doc["dept_created_tesim"]).to eq(collection.dept_created.pref_label)
      expect(solr_doc["dept_created_sim"]).to eq(collection.dept_created.pref_label)
      expect(solr_doc["depositor_full_name_tesim"]).to contain_exactly("First User")
      expect(solr_doc["collection_type_sim"]).to eq(collection.collection_type.pref_label)
      expect(solr_doc["collection_type_ssim"]).to eq(collection.collection_type.pref_label)
    end
  end
end
