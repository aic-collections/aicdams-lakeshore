# frozen_string_literal: true
require 'rails_helper'

describe "Displaying an asset" do
  let(:user)  { create(:user1) }
  let(:asset) { create(:department_asset, :with_metadata) }

  before do
    create(:exhibition, preferred_representation: asset)
    create(:work, representations: [asset])
    create(:shipment, documents: [asset])
    sign_in(user)
  end

  it "renders metadata" do
    # Display in the recent documents list
    visit(root_path)
    within("#recent_docs") do
      expect(page).to have_link(asset.keyword.first.pref_label)
      click_link(asset.pref_label)
    end

    # Show page view
    expect(page).to have_selector("h3", text: "Documents")
    expect(page).to have_selector("h3", text: "Representations")
    expect(page).to have_selector("h3", text: "Preferred Representation")
    expect(page).to have_link("Sample Exhibition")
    expect(page).to have_link("Sample Work")
    expect(page).to have_link("Sample Shipment")

    # Title and description
    expect(page).to have_selector("h1", text: asset.pref_label)
    expect(page).to have_selector("p.work_description", text: asset.description.first)

    # Attributes
    within("table.attributes") do
      expect(page).to have_selector("li.document_type", text: asset.document_type.pref_label)
      expect(page).to have_selector("li.first_document_sub_type", text: asset.first_document_sub_type.pref_label)
      expect(page).to have_selector("li.second_document_sub_type", text: asset.second_document_sub_type.pref_label)
    end
  end
end
