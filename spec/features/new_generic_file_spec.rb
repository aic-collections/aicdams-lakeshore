require 'rails_helper'

describe "Editing generic files" do

  let(:user) { FactoryGirl.create(:user) }

  before do
    sign_in user
    click_link "Upload"
  end

  describe "choosing asset type" do
    it "provides a dropdown option" do
      select("Still Image", from: "asset_type")
      select("Text", from: "asset_type")
    end

  end

end
