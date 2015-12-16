require 'rails_helper'

describe "Visting the home page", type: :feature do
  let(:user) { FactoryGirl.create(:user) }
  before do
    sign_in(user)
    visit(root_path)
  end

  it "renders the homepage" do
    expect(page).to have_content "Sufia"
    expect(page).to have_content "Advanced Search"
    within("div#advanced_search") do
      expect(page).to have_content "Contributor"
      expect(page).to have_content "Creator"
      expect(page).to have_content "Title"
    end
  end
end
