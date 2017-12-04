# frozen_string_literal: true
require 'rails_helper'

describe "Editing asset relationships" do
  context "when removing a representation that is also a preferred representation" do
    let!(:work)  { create(:work, pref_label: "Related Work") }
    let!(:asset) { create(:asset, :with_metadata,
                          pref_label: "Asset with representations",
                          representation_of_uris: [work.uri],
                          preferred_representation_of_uris: [work.uri]) }

    let(:user) { create(:user1) }

    before do
      sign_in_with_js(user)
      visit(edit_polymorphic_path(asset))
    end

    it "removes both representation and preferred representation" do
      click_link "Relationships"
      within("table.representation_of_uris") do
        expect(page).to have_content(work.pref_label)
        click_link("Remove")
      end

      click_button("Save")

      expect(page).to have_content("No relationships found for this Asset")
    end
  end
end
