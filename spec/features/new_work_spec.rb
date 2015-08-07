require 'rails_helper'

describe "Creating a new work" do

  let(:user) { FactoryGirl.create(:user) }
  let!(:asset) do
    GenericFile.new.tap do |f|
      f.title = ["asset in a work"]
      f.apply_depositor_metadata(user.user_key)
      f.save!
    end
  end

  before do
    sign_in user
    visit new_work_path
  end

  it "associates an asset with a work" do
    fill_in("work[asset_ids][]", with: asset.id)
    click_button("Create Work")
    within("div.alert") { expect(page).to have_content("A new work was created") }
  end

end
