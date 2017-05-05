# frozen_string_literal: true
require 'rails_helper'

describe CitiNotification do
  subject { described_class.new(file_set, citi_resource) }

  let(:citi_resource) { build(:work, id: "fakeid", citi_uid: "WO-fake") }
  let(:file_set)      { nil }

  context "without a file set" do
    its(:uid)           { is_expected.to eq(ENV.fetch("citi_api_uid")) }
    its(:password)      { is_expected.to eq(ENV.fetch("citi_api_password")) }
    its(:type)          { is_expected.to eq("Work") }
    its(:citi_uid)      { is_expected.to eq("WO-fake") }
    its(:image_uid)     { is_expected.to be_nil }
    its(:last_modified) { is_expected.to be_nil }
    its(:asset_details) { is_expected.to be_empty }
    its(:to_json)       { is_expected.to match(/Work/) }
  end

  context "with a file set and citi resource" do
    let(:file_set)  { build(:file_set, id: "fakefsid") }
    let(:mock_file) { double("MockFile", fcrepo_modified: [DateTime.parse("July 14")]) }

    before { allow(file_set).to receive(:original_file).and_return(mock_file) }

    its(:uid)           { is_expected.to eq(ENV.fetch("citi_api_uid")) }
    its(:password)      { is_expected.to eq(ENV.fetch("citi_api_password")) }
    its(:type)          { is_expected.to eq("Work") }
    its(:citi_uid)      { is_expected.to eq("WO-fake") }
    its(:image_uid)     { is_expected.to eq("fakefsid") }
    its(:last_modified) { is_expected.to eq("2017-07-14T00:00:00+00:00") }
    its(:to_json)       { is_expected.to match(/fakefsid/) }
  end

  context "with an asset with an image_uid" do
    let(:citi_resource) { build(:asset, imaging_uid: ["fakeimageuid"]) }

    its(:asset_details) { is_expected.to eq(image_number: "fakeimageuid") }
  end
end
