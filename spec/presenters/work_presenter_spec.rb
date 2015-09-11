require 'rails_helper'

describe WorkPresenter do

  describe "::terms" do
    it "includes all of CitiResourcePresenter terms" do
      expect(WorkPresenter.terms).to include(*CitiResourcePresenter.terms)
    end
  end

end
