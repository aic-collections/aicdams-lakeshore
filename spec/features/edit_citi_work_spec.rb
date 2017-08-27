# frozen_string_literal: true
require 'rails_helper'

describe "Editing CITI works" do
  let(:user)  { create(:user1) }
  let(:asset) { create(:asset, :with_intermediate_file_set, pref_label: "Representation of work") }
  let(:pref)  { create(:asset, pref_label: "Assigned preferred representation of work") }

  let(:notification) do
    stub_request(:post, "https://citiworker/").with(body: hash_including(citi_uid: work.citi_uid))
  end

  before do
    notification.to_return(status: 202)
    sign_in_with_named_js(:edit_work, user)
    visit(edit_polymorphic_path(work))
  end

  context "with a representation and no preferred representation" do
    let(:work) { create(:work, :with_sample_metadata, representations: [asset.uri]) }

    it "assigns the preferred representation using the first representation" do
      expect(work.preferred_representation_uri).to be_nil
      expect(selected_preferred_representation.value).to eq("")
      click_button("Save")
      expect(page).to have_selector("h3", text: "Preferred Representation")
      work.reload
      expect(work.preferred_representation_uri).to eq(asset.uri)
      expect(notification).to have_been_made
    end
  end

  context "when removing a preferred representation when other representations exist" do
    let(:work) do
      create(:work, :with_sample_metadata,
             representations: [asset.uri],
             preferred_representation_uri: pref.uri
            )
    end

    it "assigns a new preferred representation" do
      expect(selected_preferred_representation.value).to eq(pref.uri)
      find(".select2-search-choice-close").click
      click_button("Save")
      expect(page).to have_selector("h3", text: "Preferred Representation")
      work.reload
      expect(work.preferred_representation.pref_label).to eq(asset.pref_label)
      expect(notification).to have_been_made
    end
  end

  context "when a representation and a preferred representation are defined" do
    let(:work) do
      create(:work, :with_sample_metadata,
             representations: [asset.uri],
             preferred_representation_uri: pref.uri
            )
    end

    it "preserves the relationships" do
      expect(selected_preferred_representation.value).to eq(pref.uri)
      click_button("Save")
      expect(page).to have_selector("h3", text: "Preferred Representation")
      expect(notification).not_to have_been_made
    end
  end
end
