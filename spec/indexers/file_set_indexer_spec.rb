# frozen_string_literal: true
require 'rails_helper'

describe FileSetIndexer do
  describe "#generate_solr_document" do
    let(:file_set) { build(:intermediate_file_set) }
    let(:solr_doc) { described_class.new(file_set).generate_solr_document }

    it "indexes RDF types" do
      expect(solr_doc["rdf_types_ssim"]).to include(AICType.IntermediateFileSet)
      expect(solr_doc["aic_depositor_ssim"]).to eq(file_set.aic_depositor.nick)
      expect(solr_doc["depositor_full_name_tesim"]).to contain_exactly("First User")
      expect(solr_doc["dept_created_tesim"]).to eq(file_set.dept_created.pref_label)
      expect(solr_doc["dept_created_sim"]).to eq(file_set.dept_created.pref_label)
      expect(solr_doc["dept_created_citi_uid_ssim"]).to eq(file_set.dept_created.citi_uid)
    end
  end
end
