# frozen_string_literal: true
require 'rails_helper'

describe "Asset permissions" do
  before { sign_in(user) }

  describe "a department asset" do
    let!(:asset) { create(:department_asset, :with_intermediate_file_set, pref_label: "Department Visibility Asset") }

    context "with another user from the same department" do
      let(:user) { create(:department_user) }

      it "allows the user to edit and delete" do
        visit(root_path)
        fill_in(:q, with: asset.pref_label)
        click_button("Go")
        within("div#search-results") { click_link(asset.pref_label) }
        expect(page).to have_content(asset.pref_label)
        expect(page).to have_link("Delete")
        within(".related-files") do
          expect(page).to have_link("Versions")
          expect(page).to have_link("Delete")
          expect(page).to have_link("Download")
          first(:link, "Edit").click
        end
        expect(page).to have_content("Edit No Title")
        click_link("Browse View")
        expect(page).to have_link("Edit This File")
        expect(page).to have_link("Delete This File")
        visit(edit_polymorphic_path(asset))
        expect(page).to have_content(asset.pref_label)
      end
    end

    context "with another user outside the department" do
      let(:user) { create(:different_user) }

      it "allows the user to search, but not edit or view" do
        visit(root_path)
        fill_in(:q, with: asset.pref_label)
        click_button("Go")
        within("div#search-results") do
          expect(page).to have_content(asset.pref_label)
          expect(page).not_to have_link(asset.pref_label)
        end
        visit(polymorphic_path(asset))
        expect(page).to have_content("You are not authorized to see this asset.")
        visit(edit_polymorphic_path(asset))
        expect(page).to have_content("You are not authorized to see this asset.")
      end
    end
  end

  describe "an AIC asset" do
    let!(:asset) { create(:aic_asset, :with_intermediate_file_set, pref_label: "AIC Visibility Asset") }

    context "with another user from the same department" do
      let(:user) { create(:department_user) }

      it "allows the user to edit and delete" do
        visit(root_path)
        fill_in(:q, with: asset.pref_label)
        click_button("Go")
        within("div#search-results") { click_link(asset.pref_label) }
        expect(page).to have_content(asset.pref_label)
        expect(page).to have_link("Delete")
        within(".related-files") do
          expect(page).to have_link("Versions")
          expect(page).to have_link("Delete")
          expect(page).to have_link("Download")
          first(:link, "Edit").click
        end
        expect(page).to have_content("Edit No Title")
        click_link("Browse View")
        expect(page).to have_link("Edit This File")
        expect(page).to have_link("Delete This File")
        visit(edit_polymorphic_path(asset))
        expect(page).to have_content(asset.pref_label)
      end
    end

    context "with another user outside the department" do
      let(:user) { create(:different_user) }

      it "allows the user to search and view, but not edit" do
        visit(root_path)
        fill_in(:q, with: asset.pref_label)
        click_button("Go")
        within("div#search-results") { click_link(asset.pref_label) }
        expect(page).to have_content(asset.pref_label)
        expect(page).not_to have_selector("div.show_actions")
        visit(edit_polymorphic_path(asset))
        expect(page).to have_content("You are not authorized to see this asset.")
      end
    end
  end

  describe "an open access asset" do
    let!(:asset) { create(:public_asset, :with_intermediate_file_set, pref_label: "Public Visibility Asset") }

    context "with another user from the same department" do
      let(:user) { create(:department_user) }

      it "allows the user to edit and delete" do
        visit(root_path)
        fill_in(:q, with: asset.pref_label)
        click_button("Go")
        within("div#search-results") { click_link(asset.pref_label) }
        expect(page).to have_content(asset.pref_label)
        expect(page).to have_link("Delete")
        within(".related-files") do
          expect(page).to have_link("Versions")
          expect(page).to have_link("Delete")
          expect(page).to have_link("Download")
          first(:link, "Edit").click
        end
        expect(page).to have_content("Edit No Title")
        click_link("Browse View")
        expect(page).to have_link("Edit This File")
        expect(page).to have_link("Delete This File")
        visit(edit_polymorphic_path(asset))
        expect(page).to have_content(asset.pref_label)
      end
    end

    context "with another user outside the department" do
      let(:user) { create(:different_user) }

      it "allows the user to search and view, but not edit" do
        visit(root_path)
        fill_in(:q, with: asset.pref_label)
        click_button("Go")
        within("div#search-results") { click_link(asset.pref_label) }
        expect(page).to have_content(asset.pref_label)
        expect(page).not_to have_selector("div.show_actions")
        visit(edit_polymorphic_path(asset))
        expect(page).to have_content("You are not authorized to see this asset.")
      end
    end
  end
end
