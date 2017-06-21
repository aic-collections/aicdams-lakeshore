# frozen_string_literal: true
require 'rails_helper'

describe "Collection display" do
  let(:user)  { create(:user1) }
  let(:asset) { create(:department_asset, pref_label: "Asset in collection") }

  let!(:collection) { create(:department_collection, :with_metadata, members: [asset]) }

  before do
    sign_in(user)
    visit root_path
  end

  it "finds the collection in a search and displays its information" do
    fill_in(:q, with: collection.title.first)
    click_button("Go")
    within("div#search-results") do
      expect(page).to have_link(collection)
    end
    visit(polymorphic_path(collection))
    expect(page).to have_content(collection.title.first)
    within("h1") do
      expect(page).to have_selector("span.label-warning", text: "Department")
    end
    within(".metadata-collections") do
      expect(page).to have_content(collection.publish_channels.first.pref_label)
    end
    within(".table") do
      expect(page).to have_content(asset.pref_label)
    end
  end
end
