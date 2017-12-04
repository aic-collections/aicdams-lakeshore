# frozen_string_literal: true
require 'rails_helper'

describe "Editing assets" do
  let!(:agent) { create(:agent, pref_label: "Related Agent") }
  let!(:work)  { create(:work, pref_label: "Related Work") }
  let!(:asset) { create(:asset, :with_metadata,
                        representation_of_uris: [agent.uri, work.uri],
                        document_of_uris: [agent.uri],
                        attachment_of_uris: [parent_attachment.uri]) }

  let(:parent_attachment) { create(:asset, pref_label: "Parent Attachment") }

  let!(:child_attachment) { create(:asset, pref_label: "Child Attachment",
                                           attachment_of_uris: [asset.uri]) }

  let(:user) { create(:user1) }

  before do
    sign_in_with_js(user)
    visit(edit_polymorphic_path(asset))
  end

  it "renders the form with existing values" do
    click_link("Descriptions")
    expect(selected_document_type).to eq(asset.document_type_uri)
    expect(selected_first_document_sub_type).to eq(asset.first_document_sub_type_uri)
    expect(selected_second_document_sub_type).to eq(asset.second_document_sub_type_uri)
    expect(generic_work_hidden_asset_type.value).to eq(AICType.StillImage)
    expect(selected_publish_channel).to eq(asset.publish_channel_uris.first)
    expect(page).to have_field("Preferred Title", with: asset.pref_label)
    expect(page).to have_field("Description", with: asset.description.first)
    expect(page).to have_field("Alternative label", with: asset.alt_label.first)
    expect(page).to have_field("Language", with: asset.language.first)
    expect(page).to have_field("Capture Device", with: asset.capture_device)
    expect(page).to have_select("Status", selected: "Active")
    expect(page).to have_select("Publish Channels", selected: "Web", disabled: true)
    expect(page).to have_field("View Notes", with: asset.view_notes.first)
    expect(page).to have_field("Visual Surrogate", with: asset.visual_surrogate)
    expect(page).to have_field("Caption", with: asset.caption)

    expect(page).not_to have_content('string multi_value optional form-control generic_work_alt_label form-control multi-text-field')

    # Displaying hints
    within("div.generic_work_language") do
      expect(page).to have_content("The language of the asset content.")
    end
    within("div.generic_work_caption") do
      expect(page).to have_content("Non-Object Caption")
      expect(page).to have_content("A 30-character alphanumeric string serving as a caption for the asset")
    end

    click_link "Files"
    expect(page).to have_selector("li", text: "Adobe Portable Document Format")
    expect(page).to have_selector('.asset-stillimage')
    expect(page).not_to have_selector('.asset-text')
    expect(page).to have_field("URL", with: asset.external_resources.first)

    click_link "Relationships"
    within("table.representation_of_uris") do
      expect(page).to have_content(agent.pref_label)
      expect(page).to have_content(work.pref_label)
    end

    within("table.document_of_uris") do
      expect(page).to have_content(agent.pref_label)
      expect(page).not_to have_content(work.pref_label)
    end

    within("table.attachment_of_uris") do
      expect(page).to have_content(parent_attachment.pref_label)
    end

    within("table.attachment_ids") do
      expect(page).to have_content(child_attachment.pref_label)
    end
  end
end
