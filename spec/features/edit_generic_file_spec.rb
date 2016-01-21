require 'rails_helper'

describe "Editing generic files" do
  let(:user) { FactoryGirl.create(:user) }
  let(:title) { "Sample file to edit" }
  let(:file) do
    GenericFile.new.tap do |f|
      f.title = [title]
      f.apply_depositor_metadata(user.user_key)
      f.assert_still_image
      f.save!
    end
  end

  before { sign_in user }

  it "displays the correct labels" do
    visit sufia.edit_generic_file_path(file)
    match_edit_label(:document_type_ids, with: "Document Type")
    match_edit_label(:title, with: "Title")
    match_edit_label(:created_by, with: "Created By")
    match_edit_label(:description, with: "Abstract or Summary")
    match_edit_label(:language, with: "Language")
    match_edit_label(:publisher, with: "Publisher")
    match_edit_label(:rights_holder, with: "Rights Holder")
    match_edit_label(:asset_capture_device, with: "Asset Capture Device")
    match_edit_label(:status_id, with: "Status")
    match_edit_label(:digitization_source_id, with: "Digitization Source")
    match_edit_label(:compositing_id, with: "Image Compositing")
    match_edit_label(:light_type_id, with: "Image Capture Light Type")
    match_edit_label(:view_ids, with: "Image View")
    match_edit_label(:tag_ids, with: "Tag")
    match_help_link(:document_type_ids)
    match_help_link(:title)
    match_help_link(:created_by)
    match_help_link(:description)
    match_help_link(:language)
    match_help_link(:publisher)
    match_help_link(:rights_holder)
    match_help_link(:asset_capture_device)
    match_help_link(:status_id)
    match_help_link(:digitization_source_id)
    match_help_link(:compositing_id)
    match_help_link(:light_type_id)
    match_help_link(:view_ids)
    match_help_link(:tag_ids)
    visit sufia.generic_file_path(file)
    within("dl.file-show-descriptions") do
      expect(page).to have_content("UID")
      expect(page).to have_content("Legacy UID")
      expect(page).to have_content("Document Type")
      expect(page).to have_content("Status")
      expect(page).to have_content("Resource Created")
      expect(page).to have_content("Created By Department")
      expect(page).to have_content("Resource Updated")
      expect(page).to have_content("Abstract or Summary")
      expect(page).to have_content("In Batch")
      expect(page).to have_content("Language")
      expect(page).to have_content("Publisher")
      expect(page).to have_content("Rights Holder")
      expect(page).to have_content("Tag")
      expect(page).to have_content("Created By")
      expect(page).to have_content("Image Compositing")
      expect(page).to have_content("Image Capture Light Type")
      expect(page).to have_content("Image View")
      expect(page).to have_content("Asset Capture Device")
      expect(page).to have_content("Digitization Source")
    end
  end

  context "with comments" do
    let(:comment0) { "The first comment"  }
    let(:comment1) { "The second comment" }
    let(:comment2) { "The third comment"  }

    it "supports adding and removing" do
      skip "disabled for beta1 release"
      visit sufia.edit_generic_file_path(file)
      expect(page).to have_content("Edit #{title}")
      expect(page).not_to have_button("Category")
      fill_in("generic_file[comments_attributes][0][content]", with: comment0)
      click_button("upload_submit")
      expect(find_field("generic_file[comments_attributes][0][content]").value).to eql comment0
      expect(page).to have_button("Category")
      fill_in("generic_file[comments_attributes][1][content]", with: comment1)
      within("div.comments-editor") { find_button('Add').click }
      fill_in("generic_file[comments_attributes][2][content]", with: comment2)
      click_button("upload_submit")
      expect(find_field("generic_file[comments_attributes][0][content]").value).to eql comment0
      expect(find_field("generic_file[comments_attributes][1][content]").value).to eql comment1
      expect(find_field("generic_file[comments_attributes][2][content]").value).to eql comment2
      within("div.comments-editor") { first(:button, "Remove").click }
      click_button("upload_submit")
      expect(find_field("generic_file[comments_attributes][0][content]").value).to eql comment1
      expect(find_field("generic_file[comments_attributes][1][content]").value).to eql comment2
    end
  end
end
