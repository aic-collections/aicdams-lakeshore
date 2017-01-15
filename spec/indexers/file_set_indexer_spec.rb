# frozen_string_literal: true
require 'rails_helper'

describe FileSetIndexer do
  describe "#generate_solr_document" do
    let(:file_set) { build(:intermediate_file_set) }
    let(:solr_doc) { described_class.new(file_set).generate_solr_document }

    it "indexes RDF types" do
      expect(solr_doc["rdf_types_ssim"]).to include(AICType.IntermediateFileSet)
    end
  end
end
