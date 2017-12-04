# frozen_string_literal: true
require 'rails_helper'

describe CitiIndexer do
  describe "#generate_solr_document" do
    let(:work)       { build(:work, :with_sample_metadata) }
    let(:department) { build(:department, pref_label: "Department of Works") }
    let(:solr_doc)   { described_class.new(work).generate_solr_document }

    before { allow(work).to receive(:department).and_return([department]) }

    context "with a basic work" do
      it "indexes the correct fields" do
        expect(solr_doc["aic_type_sim"]).to eq("Work")
        expect(solr_doc["resource_type_tesim"]).to eq("Work")
        expect(solr_doc["relationships_isim"]).to eq(0)
        expect(solr_doc["department_tesim"]).to contain_exactly("Department of Works")
      end
    end

    context "with relationships" do
      let(:asset) { build(:asset, :with_id) }

      before { allow(work).to receive(:representations).and_return([asset]) }

      it "indexes the correct number of relationships" do
        expect(solr_doc["relationships_isim"]).to eq(1)
      end
    end
  end
end
