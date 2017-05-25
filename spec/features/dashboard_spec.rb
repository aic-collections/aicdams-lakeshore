# frozen_string_literal: true
require 'rails_helper'

describe "The dashboard" do
  let(:user1)  { create(:user1) }
  let(:user2)  { create(:user2) }

  let!(:asset)        { create(:asset, :with_metadata) }
  let!(:shared_asset) { create(:asset, :with_metadata, title: ["Shared asset"],
                                                       depositor: "user2",
                                                       edit_users: ["user1"]) }

  before { sign_in(user1) }

  it "displays the user's own assets and shared assets" do
    # My Assets tab
    visit("/dashboard/works")
    within("#search-form-header") do
      expect(page).to have_link("My Assets")
    end
    expect(page).to have_link("No Relationship")
    expect(page).to have_content(asset.pref_label.first)
    within(".batch-info") do
      expect(page).to have_button("Add to Collection", visible: false)
    end
    check("check_all")
    within(".batch-info") do
      expect(page).to have_button("Add to Collection")
    end

    # Assets Shared with Me tab
    visit("/dashboard/shares")
    expect(page).to have_content(shared_asset.pref_label.first)
    within(".batch-info") do
      expect(page).to have_button("Add to Collection", visible: false)
    end
    check("check_all")
    within(".batch-info") do
      expect(page).to have_button("Add to Collection")
    end
  end
end
