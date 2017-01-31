# frozen_string_literal: true
require 'rails_helper'

describe UnauthorizedPresenter do
  let(:resource) { create(:department_asset, pref_label: "Sample Label") }
  let(:solr_document) { SolrDocument.new(resource.to_solr) }
  let(:presenter)     { described_class.new(resource.id) }
  subject { presenter }

  before do
    allow(GenericWork).to receive(:find).with(resource.id).and_return(resource)
  end

  it "will get minimum info from the requested asset" do
    expect(subject.title_or_label).to eq("Sample Label")
    expect(subject.id).to eq(resource.id)
    expect(subject.depositor_full_name).to eq("First User")
    expect(subject.depositor_first_name).to eq("First")
    expect(subject.thumbnail_path).to eq("/assets/work-ff055336041c3f7d310ad69109eda4a887b16ec501f35afc0a547c4adb97ee72.png")
  end
end
