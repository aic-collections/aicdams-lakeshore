require 'rails_helper'

describe "CITI actors" do

  let(:user) { FactoryGirl.create(:user) }

  before { load_fedora_fixture(fedora_fixture("actor.ttl")) }

  context "when viewing" do
    before { visit(root_path) }
    it "shows all the information about the resource" do
      fill_in("q", with: "Pablo Picasso")
      click_button("Go")
      click_link("Pablo Picasso (1881-1973)")
      within("dl") do
        expect(page).to have_content("Pablo Picasso (1881-1973)")
        expect(page).to have_content("10-25-1881")
        # TODO: see issue 61
        # click_link("http://definitions.artic.edu/ontology/1.0/status/active")
      end
      within("#show_actions") { expect(page).not_to have_content("Edit") }
    end
  end

  context "when editing" do
    let!(:asset) do
      GenericFile.create.tap do |f|
        f.apply_depositor_metadata(user)
        f.assert_still_image
        f.title = ["Fixture work"]
        f.save
      end
    end

    before do
      sign_in(user)
      visit(catalog_index_path)
    end
    
    it "only adds resources" do
      click_link("Pablo Picasso (1881-1973)")
      click_link("Edit")
      fill_in("actor[document_ids][]", with: asset.id)
      fill_in("actor[representation_ids][]", with: asset.id)
      fill_in("actor[preferred_representation_ids][]", with: asset.id)
      click_button("Update Actor")
      expect(first(:field, "actor[document_ids][]").value).to eql asset.id
      expect(first(:field, "actor[representation_ids][]").value).to eql asset.id
      expect(first(:field, "actor[preferred_representation_ids][]").value).to eql asset.id
      click_link("View Actor")
      expect(page).to have_content("Representations")
      expect(page).to have_content("Preferred Representations")
      expect(page).to have_content("Documents")

    end
  end

end