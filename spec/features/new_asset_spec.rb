# frozen_string_literal: true
require 'rails_helper'

describe "Creating a new asset" do
  let(:user) { create(:user1) }
  before do
    sign_in_with_js(user)
    visit(new_polymorphic_path([main_app, GenericWork]))
  end

  it "enforces a workflow" do
    # Intial state of the form
    expect(tabs[1][:class]).to eq("disabled")
    expect(tabs[0].text).to eq("Files")
    expect(tabs[1].text).to eq("Descriptions")
    expect(tabs[2].text).to eq("Relationships")
    expect(tabs[3].text).to eq("Share")
    expect(page).to have_select("asset_type_select", selected: '')
    expect(page).not_to have_selector(".fileupload-buttonbar")
    expect(page).not_to have_selector(".asset-stillimage")
    expect(page).not_to have_selector(".asset-text")

    # Choosing the asset type enables the files tab and displays mime types
    select("Still Image", from: "asset_type_select")
    expect(tabs[1][:class]).not_to eq("disabled")
    expect(hidden_asset_type.value).to eq(AICType.StillImage)
    expect(page).to have_selector(".fileupload-buttonbar")
    expect(page).to have_selector(".asset-stillimage")
    expect(page).to have_selector("li", text: "Adobe Portable Document Format")
    expect(page).not_to have_selector(".asset-text")

    # Upload a file
    attach_file('files[]', File.join(fixture_path, "sun.png"), visible: false)
    within("div#fileupload") do
      sleep 0.1 until page.text.include?("sun.png")
    end

    # Add descriptions
    click_link("Descriptions")
    select("Imaging", from: "generic_work_document_type_uri")
    select("Event Photography", from: "generic_work_first_document_sub_type_uri")
    select("Lecture", from: "generic_work_second_document_sub_type_uri")
    fill_in("Preferred Title", with: "The Sun")

    # Save the asset, but skip characterization and derivative creation
    expect(CharacterizeJob).to receive(:perform_later)
    click_button("Save")

    # Viewing the asset
    expect(page).to have_content("The Sun")
    expect(page).to have_link("sun.png")
  end
end
