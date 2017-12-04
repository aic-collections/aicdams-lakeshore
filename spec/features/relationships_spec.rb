# frozen_string_literal: true
require 'rails_helper'

describe "Relationships of CITI resources" do
  let(:user) { create(:user1) }
  let(:work) { create(:work, citi_uid: 'WO-1234') }

  let!(:asset) do
    create(:department_asset, preferred_representation_of_uris: [work.uri],
                              representation_of_uris: [work.uri])
  end

  before do
    sign_in(user)
    visit(relationship_model_path(work.citi_uid, model: 'work'))
  end

  it "renders a page with the resource's relationships" do
    expect(page).not_to have_selector("nav#masthead")
  end
end
