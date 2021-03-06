# frozen_string_literal: true
require 'rails_helper'

describe 'curation_concerns/base/_form_share.html.erb' do
  let(:user)    { create(:user1) }
  let(:work)    { create(:department_asset, edit_users: [user]) }
  let(:ability) { double }
  let(:form)    { CurationConcerns::GenericWorkForm.new(work, ability) }

  let(:page) do
    view.simple_form_for form do |f|
      render 'curation_concerns/base/form_share.html.erb', f: f
    end
    Capybara::Node::Simple.new(rendered)
  end

  before(:all) { LakeshoreTesting.restore }

  before { allow(controller).to receive(:current_user).and_return(user) }

  context "with generic works" do
    before { allow(view).to receive(:controller_name).and_return("generic_works") }

    it "hides groups maintained by visibility and shows the depositor" do
      expect(page).not_to have_content('admin')
      expect(page).not_to have_content('registered')
      expect(page).not_to have_content('department')
      expect(page).to have_content("Depositor")
    end
  end

  context "with a public asset" do
    let(:work) { create(:public_asset, edit_users: [user]) }
    it "does not render hidden values for any implicit permission objects" do
      expect(page).not_to have_selector("#generic_work_permissions_attributes_0_id", visible: false)
    end
  end

  context "with batch edits" do
    before { allow(view).to receive(:controller_name).and_return("batch_edits") }

    it "does not show the depositor" do
      expect(page).not_to have_content("Depositor")
    end
  end
end
