require 'rails_helper'

describe "Editing permissions for lists" do
  let(:user) { create(:admin) }
  let(:list) { create(:private_list) }

  before { sign_in_with_js(user) }

  it "adds department permissions" do
    visit edit_list_path(list)

    # Add the first department
    select("Department 100", from: "new_list_group_name_skel")
    click_button("add_new_list_group_skel")
    within("table#list_permissions") do
      expect(page).to have_content("Department 100")
    end

    # Save and verify
    click_button("Update permissions")
    within("table#list_permissions") do
      expect(page).to have_content("Department 100")
    end

    # Add the second department
    select("Department 200", from: "new_list_group_name_skel")
    click_button("add_new_list_group_skel")
    within("table#list_permissions") do
      expect(page).to have_content("Department 200")
    end

    # Save and verify
    click_button("Update permissions")
    within("table#list_permissions") do
      expect(page).to have_content("Department 100")
      expect(page).to have_content("Department 200")
    end

    # Verify the list's permissions
    list.reload
    expect(list.edit_groups).to contain_exactly("citi-100", "citi-200")
  end
end
