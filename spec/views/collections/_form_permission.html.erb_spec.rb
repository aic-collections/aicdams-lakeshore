# frozen_string_literal: true
require 'rails_helper'

describe "collections/_form_permission.html.erb" do
  let(:collection) { build(:collection) }
  let(:form)       { Sufia::Forms::CollectionForm.new(collection) }

  let(:page) do
    view.simple_form_for form do |f|
      render 'collections/form_permission.html.erb', f: f
    end
    Capybara::Node::Simple.new(rendered)
  end

  subject { page }

  before { assign(:collection, collection) }

  context "with a private collection" do
    let(:collection) { build(:private_collection) }
    it { is_expected.to have_checked_field("Private") }
  end

  context "with a department collection" do
    let(:collection) { build(:department_collection) }
    it { is_expected.to have_checked_field("Department") }
    it { is_expected.not_to have_checked_field("Private") }
  end

  context "with a registered collection" do
    let(:collection) { build(:registered_collection) }
    it { is_expected.to have_checked_field("AIC") }
  end

  context "with a public collection" do
    let(:collection) { build(:public_collection) }
    it { is_expected.to have_checked_field("Open Access") }
  end
end
