# frozen_string_literal: true
require 'rails_helper'

describe UnauthorizedPresenter do
  let(:id) { "1234" }
  let(:asset) { build(:department_asset, id: "1234", pref_label: "Sample Label") }
  let(:solr_document) { SolrDocument.new(asset.to_solr) }
  let(:depositor) { build(:aic_user) }
  let(:presenter)     { described_class.new(id) }
  subject { presenter }

  it "will get minimum info from the requested asset" do
    allow(GenericWork).to receive(:find).with(id).and_return(asset)
    allow(asset).to receive(:aic_depositor).and_return(depositor)

    expect(subject.title).to eq("Sample Label")
    expect(subject.depositor).to eq("Joe Bob")
    expect(subject.thumbnail).to eq("/assets/work-ff055336041c3f7d310ad69109eda4a887b16ec501f35afc0a547c4adb97ee72.png")
    expect(subject.message).to eq("You are not authorized to see this asset. Please contact Joe Bob if you would like to request access to it.")
  end
end
