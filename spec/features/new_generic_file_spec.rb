require 'rails_helper'

describe "Editing generic files" do
  let(:user) { FactoryGirl.create(:user) }

  before do
    sign_in_with_js user
    visit("/dashboard")
    click_link "Upload"
  end

  describe "choosing asset type" do
    it "displays the file selection form" do
      expect(page).not_to have_content(" I have read and do agree")
      select("Still Image", from: "asset_type")
      expect(page).to have_content(" I have read and do agree")
      select("Text", from: "asset_type")
      expect(page).to have_content(" I have read and do agree")
      select("Select...", from: "asset_type")
      expect(page).not_to have_content(" I have read and do agree")
    end
  end
end
