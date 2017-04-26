# frozen_string_literal: true
require 'rails_helper'

describe "collections/_form_metadata.html.erb" do
  let(:collection) { build(:collection) }
  let(:form)       { Sufia::Forms::CollectionForm.new(collection) }

  let(:page) do
    view.simple_form_for form do |f|
      render 'collections/form_metadata.html.erb', f: f
    end
    Capybara::Node::Simple.new(rendered)
  end

  before { stub_template 'collections/_form_permission.html.erb' => '' }

  it "renders the metadata fields" do
    expect(page).to have_selector("input#collection_title")
  end
end
