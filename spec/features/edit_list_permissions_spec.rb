# frozen_string_literal: true
require 'rails_helper'

describe "Editing permissions for lists" do
  let(:admin) { create(:admin) }
  let(:user) { create(:user2) }
  let(:list) { create(:private_list, pref_label: 'user2 items') }

  it "adds department permissions" do
    skip
    sign_in_with_js(admin)
    visit edit_list_path(list)
    select("Department 200", from: "new_list_group_name_skel")
    click_button("add_new_list_group_skel")
    within("table#list_permissions") do
      expect(page).to have_content("Department 200")
    end
    click_button("Update permissions")
    sign_in_with_js(user)
    visit root_path
    visit lists_path
    within("#user2-items_list") do
      expect(page).to have_link("Modify items")
    end
  end
end
