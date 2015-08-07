require 'rails_helper'

describe WorkEditForm do
  subject { described_class.new(Work.new) }

  describe ".model_attributes" do
    let(:params) do 
      ActionController::Parameters.new( asset_ids: [""] )
    end
    subject { described_class.model_attributes(params) }

    it "removes empty strings" do
      expect(subject["asset_ids"]).to be_empty
    end
  end

end