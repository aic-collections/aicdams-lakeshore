require 'rails_helper'

describe "Lists" do

  let(:user) { FactoryGirl.create(:user) }
  let(:list) { List.where(pref_label: "My List").first }

  before do
    List.create(pref_label: "My List")
    sign_in(user)
    visit(lists_path)
  end

  specify "may have items curated by the user" do
    # List page
    expect(page).to have_link("My Dashboard")
    within("#my_list_list") do
      expect(page).to have_content("My List")
      click_link("Modify items")
    end

    # My List page
    expect(page).to have_link("My Dashboard")
    expect(page).to have_link("Lists")
    expect(page).to have_content("View List")
    click_link("Add items")
    sleep(5)
    fill_in("list_item[pref_label]", with: "My Item")
    click_button("Create List item")
    expect(page).to have_content("My Item")
    click_link("Edit")
    sleep(5)
    fill_in("list_item[description][]", with: "some description")
    click_button("Update List item")
    expect(page).to have_content("some description")
  end

end
