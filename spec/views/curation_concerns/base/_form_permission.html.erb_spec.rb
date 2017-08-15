# frozen_string_literal: true
require 'rails_helper'

describe "curation_concerns/base/_form_permission.html.erb" do
  let(:user) { create(:user1) }
  let(:form) { BatchEditForm.new(GenericWork.new, double, ["1", "2"]) }

  let(:page) do
    view.simple_form_for form do |f|
      render 'curation_concerns/base/form_permission.html.erb', f: f
    end
    Capybara::Node::Simple.new(rendered)
  end

  it "renders Lakeshore visibilities" do
    expect(page).to have_no_checked_field("Private")
    expect(page).to have_checked_field("Department")
  end
end
