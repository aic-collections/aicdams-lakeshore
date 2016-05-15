# frozen_string_literal: true
require 'rails_helper'

describe UpdateIndexJob do
  let(:object) { create(:asset) }
  let(:job) { described_class.perform_now(object.id) }

  it "updates the index of a single object" do
    expect(job["responseHeader"]["status"]).to eql 0
  end
end
