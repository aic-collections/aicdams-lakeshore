require 'rails_helper'

describe "Displaying a work from CITI" do

  before do
    load_fedora_fixture(fedora_fixture("work.ttl"))
    visit catalog_index_path
  end

  it "shows all the information about the resource" do
    expect(page).to have_content("The Great Sidewalk Gum")
  end

end
