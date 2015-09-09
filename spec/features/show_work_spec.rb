require 'rails_helper'

describe "Displaying a work from CITI" do

  before do
    load_fedora_fixture(fedora_fixture("work.ttl"))
    visit catalog_index_path
  end

  it "shows all the information about the resource" do
    click_link("The Great Sidewalk Gum")
    within("dl") do
      expect(page).to have_content("The Great Sidewalk Gum")
      expect(page).to have_content("Gift of Mr. Dummy Lee & Mrs. Parrot Funkaroo")
      click_link("http://definitions.artic.edu/ontology/1.0/status/active")
    end

  end

end
