# frozen_string_literal: true
require 'rails_helper'

describe "Editing collections" do
  let!(:collection) { create(:collection, :with_metadata) }

  before do
    sign_in_with_js(user)
    visit(edit_polymorphic_path(collection))
  end

  context "with an admin user" do
    let(:user) { create(:admin) }

    it "allows editing of all fields" do
      have_select('collection_publish_channel_uris', selected: "Web", disabled: false)
    end
  end

  context "with a standard user" do
    let(:user) { create(:user1) }

    it "allows editing of all fields" do
      have_select('collection_publish_channel_uris', selected: "Web", disabled: true)
    end
  end
end
