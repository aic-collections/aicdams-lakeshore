# frozen_string_literal: true
require 'rails_helper'

describe Lakeshore::ReindexController do
  let(:user) { create(:apiuser) }

  before { sign_in_basic(user) }

  describe "#create" do
    context "with correct input" do
      let(:body) { '["res1"]' }
      before { allow(ActiveFedora::Base).to receive(:exists?).and_return(true) }
      it "returns a successful response" do
        expect(UpdateIndexJob).to receive(:perform_later).with("res1", nil)
        post :create, body
        expect(response.status).to eql 204
      end
    end

    context "with a custom queue" do
      let(:body) { '["res1"]' }
      before { allow(ActiveFedora::Base).to receive(:exists?).and_return(true) }
      it "returns a successful response" do
        expect(UpdateIndexJob).to receive(:perform_later).with("res1", "special")
        post :create, body, queue: "special"
        expect(response.status).to eql 204
      end
    end

    context "when the fedora object does not exist" do
      let(:body) { '["missing"]' }
      before { post :create, body }
      subject { response.status }
      it { is_expected.to eql 204 }
    end

    context "with incorrect input" do
      let(:body) { '{"bogus": "json"}' }
      before { post :create, body }
      subject { response.status }
      it { is_expected.to eql 400 }
    end

    context "with bogus input" do
      before { post :create, "junk" }
      subject { response.status }
      it { is_expected.to eql 400 }
    end
  end
end
