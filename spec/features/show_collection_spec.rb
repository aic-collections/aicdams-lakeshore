# frozen_string_literal: true
require 'rails_helper'

describe "Collection display" do
  let(:user)       { create(:user1) }
  let(:asset)      { create(:department_asset, pref_label: "Asset in collection") }

  let!(:collection) { create(:department_collection, title: ["Sample collection"], members: [asset]) }

  before do
    sign_in(user)
    visit "/dashboard/collections"
  end

  it "displays the collection" do
    # From the collection's dashboard
    expect(page).to have_selector("span.label-warning", text: "Department")
    within("#documents") do
      first(:link, collection.title.first).click
    end

    # From the collection's show view
    expect(page).to have_content(collection.title.first)
    within("h1") do
      expect(page).to have_selector("span.label-warning", text: "Department")
    end
    within(".table") do
      expect(page).to have_content(asset.pref_label)
    end
  end
end
