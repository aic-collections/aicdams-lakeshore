# frozen_string_literal: true
require 'rails_helper'

describe FileSet do
  let!(:asset) { create(:department_asset) }
  let!(:file)  { create(:department_file, title: ["Sample File Set"]) }

  let(:user) { create(:user1) }

  before do
    asset.ordered_members = [file]
    file.access_control_id = asset.access_control_id
    file.save
    asset.save
    sign_in(user)
    visit(edit_polymorphic_path(file))
  end

  it "renders the edit page" do
    expect(page).to have_content("Edit Sample File Set")
    expect(page).not_to have_selector("#permissions_display")
    fill_in("Title", with: "Updated File Set")
    click_button("Update Attached File")
    expect(page).to have_content("Updated File Set")
  end
end
