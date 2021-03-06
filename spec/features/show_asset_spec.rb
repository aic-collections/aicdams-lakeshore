# frozen_string_literal: true
require 'rails_helper'

describe "Displaying an asset" do
  let(:user)        { create(:user1) }
  let(:attachment)  { create(:asset, pref_label: "Sample Attachment") }
  let(:constituent) { create(:asset, pref_label: "Sample Constituent Of") }
  let(:asset)       { create(:department_asset, :with_metadata, :with_license_metadata,
                             attachments: [attachment.uri],
                             constituent_of: [constituent.uri]) }

  before do
    LakeshoreTesting.restore
    create(:exhibition, preferred_representation: asset.uri)
    create(:work, representations: [asset.uri])
    create(:shipment, documents: [asset.uri])
    create(:asset, pref_label: "Sample Has Constituent Part", constituent_of: [asset.uri])
    sign_in(user)
  end

  it "renders metadata" do
    # Index search results
    visit(root_path)
    fill_in(:q, with: asset.pref_label)
    click_button("Go")
    within("#document_#{asset.id}") do
      expect(page).to have_selector("th", text: "Title")
      expect(page).to have_selector("td", text: asset.pref_label)
      expect(page).to have_selector("th", text: AIC.uid.label)
      expect(page).to have_selector("td", text: asset.uid)
      expect(page).to have_selector("th", text: AIC.deptCreated.label)
      expect(page).to have_selector("td", text: asset.dept_created.pref_label)
      expect(page).to have_selector("th", text: AIC.documentType.label)
      expect(page).to have_selector("td", text: "Imaging > Event Photography > Lecture")
      doc_type_td = page.find(:xpath, '//td[contains(., "Imaging > Event Photography > Lecture")]')
      expect(doc_type_td).to have_link("Imaging")
      expect(doc_type_td).to have_link("Event Photography")
      expect(doc_type_td).to have_link("Lecture")
      expect(page).to have_selector("td", text: "10/31/2016")
      expect(page).to have_selector("td", text: "10/30/2016")
      expect(page).to have_link(asset.depositor)

      click_link("Imaging")
    end

    # Check faceted search from results list content,
    # accessed from "Imaging" link
    expect(page).to have_content('1 entry found')
    expect(page).to have_content('You searched for: Document Type Imaging')

    # Check that our facets are displayed
    within("#facets") do
      expect(page).to have_selector("h3", text: AIC.deptCreated.label)
      expect(page).to have_selector("h3", text: AIC.documentType.label)
      expect(page).to have_selector("h3", text: AIC.publishChannel.label)
      expect(page).to have_selector("h3", text: "Resource Type")
    end

    click_link(asset.pref_label)

    # Show page view
    expect(page).to have_selector("h3", text: "Preferred Representation Of")
    expect(page).to have_selector("h3", text: "Representation Of")
    expect(page).to have_selector("h3", text: "Documentation For")
    expect(page).to have_selector("h3", text: "Attachment Of")
    expect(page).to have_selector("h3", text: "Is Constituent Part Of")

    # User1 gets links to the assets
    expect(page).to have_link("Sample Exhibition")
    expect(page).to have_link("Sample Work")
    expect(page).to have_link("Sample Shipment")
    expect(page).to have_link("Sample Attachment")
    expect(page).to have_link("Sample Constituent Of")
    expect(page).to have_link("Sample Has Constituent Part")

    # Title and description
    expect(page).to have_selector("h1", text: asset.pref_label)
    expect(page).to have_selector("p.work_description", text: asset.description.first)

    # Attributes
    within("table.attributes") do
      expect(page).to have_selector("li.document_types", text: "Imaging > Event Photography > Lecture")
      expect(page).to have_selector("li.view", text: asset.view.first.pref_label)
      expect(page).to have_selector("li.keyword", text: asset.keyword.first.pref_label)
      expect(page).to have_selector("li.capture_device", text: asset.capture_device)
      expect(page).to have_selector("li.digitization_source", text: asset.digitization_source.pref_label)
      expect(page).to have_content(asset.legacy_uid.first)
      expect(page).to have_content(asset.legacy_uid.last)
      expect(page).to have_selector("li.compositing", text: asset.compositing.pref_label)
      expect(page).to have_selector("li.light_type", text: asset.light_type.pref_label)
      expect(page).to have_selector("li.imaging_uid", text: asset.imaging_uid.first)
      expect(page).to have_selector("li.transcript", text: asset.transcript)
      expect(page).to have_selector("li.status", text: asset.status.pref_label)
      expect(page).to have_selector("li.dept_created", text: asset.dept_created.pref_label)
      expect(page).to have_selector("li.aic_depositor", text: asset.aic_depositor.nick)
      expect(page).to have_selector("li.alt_label", text: asset.alt_label.first)
      expect(page).to have_selector("li.batch_uid", text: asset.batch_uid)
      expect(page).to have_selector("li.create_date", text: asset.create_date.strftime("%m/%d/%Y"))
      expect(page).to have_selector("li.modified_date", text: asset.modified_date.strftime("%m/%d/%Y"))
      expect(page).to have_selector("li.language", text: asset.language.first)
      expect(page).to have_selector("li.publish_channels", text: asset.publish_channels.first.pref_label)
      expect(page).to have_selector("li.view_notes", text: asset.view_notes.first)
      expect(page).to have_selector("li.visual_surrogate", text: asset.visual_surrogate)
      expect(page).to have_selector("th", "Non-Object Caption")
      expect(page).to have_selector("li.caption", text: asset.caption)

      within(".external_resources") do
        expect(page).to have_link(asset.external_resources.first)
      end

      expect(page).to have_selector("li.licensing_restrictions", text: asset.licensing_restrictions.first.pref_label)
      expect(page).to have_selector("li.public_domain", text: "No")
      expect(page).to have_selector("li.publishable", text: "No")
      expect(page).to have_selector("li.copyright_representatives", text: asset.copyright_representatives.first.pref_label)
    end
  end
end
