require 'rails_helper'

describe UpdateIndexJob do
  let(:object) do
    GenericFile.create.tap do |f|
      f.apply_depositor_metadata "user"
      f.assert_still_image
      f.save
    end
  end

  let(:job) { described_class.new(object.id).run }

  it "updates the index of a single object" do
    expect(job["responseHeader"]["status"]).to eql 0
  end
end
