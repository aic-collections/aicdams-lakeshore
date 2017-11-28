# frozen_string_literal: true
require 'rails_helper'

describe "Editing asset permissions" do
  let!(:user)     { create(:default_user) }
  let!(:other)    { create(:different_user) }
  let!(:asset)    { create(:department_asset, :with_metadata, edit_users: [other]) }
  let!(:file_set) { create(:intermediate_file_set, edit_users: [other]) }

  before do
    asset.ordered_members = [file_set]
    file_set.access_control_id = asset.access_control_id
    file_set.save
    asset.save
    sign_in_with_js(user)
    visit(edit_polymorphic_path(asset))
  end

  context "when changing the visibility of an asset" do
    it "indexes the same permissions on the file set" do
      within("ul.nav-tabs") { click_link("Share") }
      within("#savewidget") do
        choose('generic_work_visibility_open')
      end

      click_button("Save")
      expect(page).not_to have_content("Apply changes to contents?")
      expect(page).to have_content(asset.pref_label.first)
      asset.reload
      expect(asset.file_sets.first.access_control_id).to eq(asset.access_control_id)
      expect(asset.visibility).to eq("open")
      expect(SolrDocument.find(asset.id).visibility).to eq("open")
      expect(asset.file_sets.first.visibility).to eq("open")
      expect(SolrDocument.find(asset.file_sets.first.id).visibility).to eq("open")
    end
  end

  context "when changing the sharing of an asset" do
    it "indexes the same permissions on the file set" do
      within("ul.nav-tabs") { click_link("Share") }
      find(".remove_perm").click

      click_button("Save")
      expect(page).not_to have_content("Apply changes to contents?")
      expect(page).to have_content(asset.pref_label.first)
      asset.reload
      expect(asset.edit_users).to contain_exactly(user.user_key)
      expect(SolrDocument.find(asset.id)["edit_access_person_ssim"]).to contain_exactly(user.user_key)
      expect(asset.file_sets.first.edit_users).to contain_exactly(user.user_key)
      expect(SolrDocument.find(asset.file_sets.first.id)["edit_access_person_ssim"]).to contain_exactly(user.user_key)
    end
  end
end
