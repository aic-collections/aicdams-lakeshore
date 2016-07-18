# frozen_string_literal: true
require 'rails_helper'

describe "Representations of CITI resources" do
  let(:user)  { create(:user1) }
  let(:asset) { create(:department_asset) }
  let(:work)  { create(:work, citi_uid: 'WO-1234', preferred_representation: asset) }

  before do
    sign_in(user)
    visit(representation_path(work.citi_uid))
  end

  it "renders a page with the resource's representations" do
    expect(page).not_to have_selector("nav#masthead")
    expect(page).to have_content("Relationships")
  end
end
