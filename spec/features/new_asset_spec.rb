# frozen_string_literal: true
require 'rails_helper'

describe "Creating a new asset" do
  let(:user) { create(:user1) }
  before do
    sign_in(user)
    visit(new_polymorphic_path([main_app, GenericWork]))
  end

  # Test TBA
  xit "enforces the asset type" do
  end
end
