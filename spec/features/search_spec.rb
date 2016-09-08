# frozen_string_literal: true
require 'rails_helper'

describe "Searching" do
  let!(:user1) { create(:user1) }
  let!(:user2)            { create(:user2) }
  let!(:department_asset) { create(:department_asset, pref_label: "Department Asset") }
  let!(:registered_asset) { create(:registered_asset, pref_label: "Registered Asset") }
  let!(:work)             { create(:work, :with_sample_metadata, department: [Department.find_by_citi_uid("100").uri]) }

  before do
    sign_in(user2)
  end

  it "displays search results for all assets" do
    # Search returns links to available assets only
    visit(root_path)
    fill_in(:q, with: "Asset")
    click_button("Go")
    within("div#search-results") do
      expect(page).to have_link(registered_asset)
      expect(page).not_to have_link(department_asset)
    end
    visit(polymorphic_path(department_asset))
    expect(page).to have_content("The page you have tried to access is private")

    # Searching on uid
    visit(root_path)
    fill_in(:q, with: registered_asset.uid.split(/-/).last)
    click_button("Go")
    within("div#search-results") do
      expect(page).to have_link(registered_asset)
    end
  end

  it "displays search results for non-assets" do
    visit(root_path)
    fill_in(:q, with: "Great Sidewalk Gum")
    click_button("Go")
    within("div#search-results") do
      expect(page).to have_selector("td", text: "Department 100")
    end
  end
end
