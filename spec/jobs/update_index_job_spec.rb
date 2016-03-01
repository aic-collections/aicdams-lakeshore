require 'rails_helper'

describe UpdateIndexJob do
  let(:object) { create(:asset) }
  let(:job) { described_class.new(object.id).run }

  it "updates the index of a single object" do
    expect(job["responseHeader"]["status"]).to eql 0
  end
end
