require 'rails_helper'

describe "Visting the home page", type: :feature do

  before { visit "/" }

  context "as an unauthenticated user" do

    it "renders the homepage" do
      expect(page).to have_content "Sufia"
    end
  
  end

end
