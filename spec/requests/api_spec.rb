# frozen_string_literal: true
require 'rails_helper'

describe "The API" do
  describe "reindexing resources" do
    context "with correct input" do
      let(:body) { '["res1"]' }
      before { allow(ActiveFedora::Base).to receive(:exists?).and_return(true) }
      it "returns a successful response" do
        expect(UpdateIndexJob).to receive(:perform_later).with("res1")
        post "/api/reindex", body
        expect(response.status).to eql 204
      end
    end

    context "when the fedora object does not exist" do
      let(:body) { '["missing"]' }
      before { post "/api/reindex", body }
      subject { response.status }
      it { is_expected.to eql 204 }
    end

    context "with incorrect input" do
      let(:body) { '{"bogus": "json"}' }
      before { post "/api/reindex", body }
      subject { response.status }
      it { is_expected.to eql 400 }
    end

    context "with bogus input" do
      before { post "/api/reindex", "junk" }
      subject { response.status }
      it { is_expected.to eql 500 }
    end
  end
end
