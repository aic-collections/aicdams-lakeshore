require 'rails_helper'

describe WorkPresenter do

  let(:nested_terms) { [:comments, :aictags, :location, :metadata, :publishing_context] }
  let(:terms) { AssetPresenter.terms - nested_terms }

  describe "::terms" do
    it "includes all of AssetPresenter terms" do
      expect(WorkPresenter.terms).to include(*terms)
    end
  end

end
