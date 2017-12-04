# frozen_string_literal: true
require 'rails_helper'

describe "Editing CITI works" do
  let(:user)  { create(:user1) }
  let(:work)  { create(:work, :with_sample_metadata) }
  let(:asset) { create(:asset, :with_intermediate_file_set, pref_label: "Asset related to work") }
  let(:pref)  { create(:asset, :with_intermediate_file_set, pref_label: "Assigned preferred representation of work") }

  let(:notification) do
    stub_request(:post, "https://citiworker/").with(body: hash_including(citi_uid: work.citi_uid))
  end

  before do
    notification.to_return(status: 202)
    sign_in_with_named_js(:edit_work, user)
  end

  context "when no changes are made" do
    before do
      asset.representation_of_uris = [work.uri]
      asset.document_of_uris = [work.uri]
      pref.representation_of_uris = [work.uri]
      pref.preferred_representation_of_uris = [work.uri]
      asset.save
      pref.save
    end

    it "maintains all the existing relationships" do
      visit(edit_polymorphic_path(work))

      within("table.document_ids") do
        expect(page).to have_content("Asset related to work")
      end

      expect(page).to have_selector("h4", text: "Documents")
      within("table.document_ids") do
        expect(page).to have_content("Asset related to work")
      end

      expect(page).to have_selector("h4", text: "Representations")
      within("table.representation_ids") do
        within(all("tr")[0]) do
          expect(page).to have_css(".aic-star-on")
          expect(page).to have_content("Assigned preferred representation of work")
        end
        within(all("tr")[1]) do
          expect(page).to have_css(".aic-star-off")
          expect(page).to have_content("Asset related to work")
        end
      end

      click_button("Save")

      within(all("table.relationships")[0]) do
        within(all("tr")[1]) do
          expect(page).to have_css(".aic-star-on")
          expect(page).to have_content("Assigned preferred representation of work")
        end
        within(all("tr")[2]) do
          expect(page).to have_css(".aic-star-off")
          expect(page).to have_content("Asset related to work")
        end
      end

      within(all("table.relationships")[1]) do
        expect(page).to have_content("Asset related to work")
      end

      asset.reload
      expect(asset.representation_of_uris).to contain_exactly(work.uri)
      expect(asset.document_of_uris).to contain_exactly(work.uri)
      pref.reload
      expect(pref.representation_of_uris).to contain_exactly(work.uri)
      expect(pref.preferred_representation_of_uris).to contain_exactly(work.uri)
      expect(notification).not_to have_been_made
    end
  end

  context "with a representation and no preferred representation" do
    before do
      asset.representation_of_uris = [work.uri]
      asset.save
    end

    it "assigns the preferred representation using the first representation and notifies CITI" do
      visit(edit_polymorphic_path(work))

      # Because no pref. rep. is present, no highlighted star is rendered.
      within("table.representation_ids") do
        expect(page).to have_content("Asset related to work")
        expect(all("tr")[0]).to have_css(".aic-star-off")
      end

      click_button("Save")

      within("table.relationships") do
        expect(page).to have_content("Asset related to work")
        expect(all("tr")[1]).to have_css(".aic-star-on")
      end

      asset.reload
      expect(asset.preferred_representation_of_uris).to contain_exactly(work.uri)
      expect(notification).to have_been_made
    end
  end

  context "when changing a preferred representation" do
    before do
      asset.representation_of_uris = [work.uri]
      pref.representation_of_uris = [work.uri]
      pref.preferred_representation_of_uris = [work.uri]
      asset.save
      pref.save
    end

    it "updates the assets and notifies CITI" do
      visit(edit_polymorphic_path(work))

      within("table.representation_ids") do
        within(all("tr")[0]) do
          expect(page).to have_css(".aic-star-on")
          expect(page).to have_content("Assigned preferred representation of work")
        end
        within(all("tr")[1]) do
          expect(page).to have_content("Asset related to work")
          find(".aic-star-off").click
        end
      end

      click_button("Save")

      within("table.relationships") do
        within(all("tr")[1]) do
          expect(page).to have_css(".aic-star-on")
          expect(page).to have_content("Asset related to work")
        end
        within(all("tr")[2]) do
          expect(page).to have_css(".aic-star-off")
          expect(page).to have_content("Assigned preferred representation of work")
        end
      end

      asset.reload
      expect(asset.preferred_representation_of_uris).to contain_exactly(work.uri)
      pref.reload
      expect(pref.preferred_representation_of_uris).to be_empty
      expect(notification).to have_been_made
    end
  end

  context "when removing relationships" do
    before do
      asset.representation_of_uris = [work.uri]
      pref.representation_of_uris = [work.uri]
      pref.preferred_representation_of_uris = [work.uri]
      asset.save
      pref.save
    end

    it "updates the assets and notifies CITI" do
      visit(edit_polymorphic_path(work))

      page.all(".am-delete")[0].click while page.all(".am-delete").count == 2

      page.all(".am-delete")[0].click while page.all(".am-delete").count == 1

      click_button("Save")

      asset.reload
      expect(asset.preferred_representation_of_uris).to be_empty
      expect(asset.representation_of_uris).to be_empty
      pref.reload
      expect(pref.preferred_representation_of_uris).to be_empty
      expect(pref.representation_of_uris).to be_empty
      expect(notification).to have_been_made
    end
  end
end
