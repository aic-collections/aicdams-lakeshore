# frozen_string_literal: true
require 'rails_helper'

describe AclJob do
  let(:asset)        { build(:asset) }
  let(:mock_service) { double }

  before { allow(ActiveFedora::Base).to receive(:find).with("asset-id").and_return(asset) }

  context "when using the default queue" do
    let(:job) { described_class.new("asset-id") }

    it "calls AclService" do
      expect(AclService).to receive(:new).with(asset).and_return(mock_service)
      expect(mock_service).to receive(:update)
      job.perform_now
    end
  end

  context "when using a custom queue" do
    let(:job) { described_class.new("asset-id", "special") }

    it "calls AclService" do
      expect(AclService).to receive(:new).with(asset).and_return(mock_service)
      expect(mock_service).to receive(:update)
      expect(job.queue_name).to eq("special")
      job.perform_now
    end
  end
end
