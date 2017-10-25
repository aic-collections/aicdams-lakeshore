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

    # Check requirements status
    expect(page).to have_selector("#required-metadata", text: "Enter required metadata")
    expect(page).to have_selector("#required-files", text: "Add files")
    expect(page).to have_selector("#upload-errors", text: "No failed uploads")
    expect(page).to have_button('Save', disabled: true)

    # Choosing the asset type enables the files tab and displays mime types
    select("Still Image", from: "asset_type_select")
    expect(tabs[1][:class]).not_to eq("disabled")
    expect(hidden_asset_type.value).to eq(AICType.StillImage)
    expect(page).to have_selector(".fileupload-buttonbar")
    expect(page).to have_selector(".asset-stillimage")
    expect(page).to have_selector("li", text: "Adobe Portable Document Format")
    expect(page).not_to have_selector(".asset-text")

    # Upload the wrong type of file
    attach_file('files[]', File.join(fixture_path, "text.txt"), visible: false)
    within("div#fileupload") { sleep 0.1 until page.text.include?("text.txt") }

    # Check requirements status
    expect(page).to have_selector("#required-metadata", text: "Enter required metadata")
    expect(page).to have_selector("#required-files", text: "Files requirement complete")
    expect(page).to have_selector("#upload-errors", text: "Files failed to upload. Please remove them from the queue before saving.")
    expect(page).to have_button('Save', disabled: true)

    # Delete bad file and upload a correct one
    click_button("Delete")
    within("div#fileupload") { sleep 0.1 while page.text.include?("text.txt") }
    attach_file('files[]', File.join(fixture_path, "sun.png"), visible: false)
    within("div#fileupload") { sleep 0.1 until page.text.include?("sun.png") }

    # Check requirements status
    expect(page).to have_selector("#required-metadata", text: "Enter required metadata")
    expect(page).to have_selector("#required-files", text: "Files requirement complete")
    expect(page).to have_selector("#upload-errors", text: "No failed uploads")
    expect(page).to have_button('Save', disabled: true)

    # Add descriptions
    click_link("Descriptions")
    select("Imaging", from: "generic_work_document_type_uri")
    select("Event Photography", from: "generic_work_first_document_sub_type_uri")
    select("Lecture", from: "generic_work_second_document_sub_type_uri")
    fill_in("Preferred Title", with: "The Sun")

    # Check requirements status
    expect(page).to have_selector("#required-metadata", text: "Metadata requirement complete")
    expect(page).to have_selector("#required-files", text: "Files requirement complete")
    expect(page).to have_selector("#upload-errors", text: "No failed uploads")
    expect(page).to have_button('Save', disabled: false)

    # Go back to files and set the wrong file set type
    click_link("Files")
    within(".files") do
      id = find("select")[:id]
      select("Original File Set", from: id)
    end

    # Check requirements status
    expect(page).to have_selector("#required-metadata", text: "Metadata requirement complete")
    expect(page).to have_selector("#required-files", text: "Add files")
    expect(page).to have_selector("#upload-errors", text: "No failed uploads")
    expect(page).to have_button('Save', disabled: true)

    within(".files") do
      id = find("select")[:id]
      select("Intermediate File Set", from: id)
    end

    # Check requirements status
    expect(page).to have_selector("#required-metadata", text: "Metadata requirement complete")
    expect(page).to have_selector("#required-files", text: "Files requirement complete")
    expect(page).to have_selector("#upload-errors", text: "No failed uploads")
    expect(page).to have_button('Save', disabled: false)

    # Save the asset, but skip characterization and derivative creation
    expect(CharacterizeJob).to receive(:perform_later)
    click_button("Save")

    # Viewing the asset
    expect(page).to have_content("The Sun")
    expect(page).to have_link("sun.png")
  end
end
