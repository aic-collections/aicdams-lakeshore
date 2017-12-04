# frozen_string_literal: true
require 'rails_helper'

describe CitiResourceMetadata do
  before(:all) do
    class CitiResourceMetadataClass < ActiveFedora::Base
      include CitiResourceMetadata
    end
  end

  after(:all) do
    Object.send(:remove_const, :UriTestClass) if defined?(UriTestClass)
  end

  describe "#citi_uid" do
    subject { CitiResourceMetadataClass.properties["citi_uid"] }
    it { is_expected.not_to be_multiple }
  end

  describe "::find_by_citi_uid" do
    before { CitiResourceMetadataClass.create(citi_uid: "AB-1234") }

    subject { CitiResourceMetadataClass.find_by_citi_uid(id) }

    context "with an exact search" do
      let(:id) { "AB-1234" }
      its(:citi_uid) { is_expected.to eq(id) }
    end

    context "with a fuzzy search" do
      let(:id) { "AB-1" }
      it { is_expected.to be_nil }
    end

    context "with a nil id" do
      let(:id) { nil }
      it { is_expected.to be_nil }
    end
  end
end
