# frozen_string_literal: true
require 'rails_helper'

describe FileSet do
  let(:file) { build(:department_file, id: '1234') }

  subject { file }

  describe "#to_solr" do
    xit "contains our custom solr fields" do
      expect(subject.to_solr[Solrizer.solr_name("file_size", :stored_sortable, type: :integer)]).to eq "1234"
      expect(subject.to_solr[Solrizer.solr_name("image_width", :searchable, type: :integer)]).to eq 8
      expect(subject.to_solr[Solrizer.solr_name("image_height", :searchable, type: :integer)]).to eq 12
    end
  end

  describe "#id" do
    let(:file) { create(:department_file) }
    its(:id) { is_expected.to match(/[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}/) }
  end
end
