# frozen_string_literal: true
require 'rails_helper'

describe UpdateIndexJob do
  let(:object) { create(:asset) }

  context "when using the default queue" do
    let(:job) { described_class.new(object.id) }

    it "updates the index of a single object" do
      expect(job.queue_name).to eq("resolrize")
      expect(job.perform_now["responseHeader"]["status"]).to eq(0)
    end
  end

  context "when using a custom queue" do
    let(:job) { described_class.new(object.id, "special") }

    it "updates the index of a single object" do
      expect(job.queue_name).to eq("special")
      expect(job.perform_now["responseHeader"]["status"]).to eq(0)
    end
  end
end
