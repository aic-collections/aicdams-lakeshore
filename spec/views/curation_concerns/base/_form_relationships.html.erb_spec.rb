# frozen_string_literal: true
require 'rails_helper'

describe 'curation_concerns/base/_form_relationships.html.erb' do
  let(:user)    { create(:user1) }
  let(:asset)   { create(:department_asset) }
  let(:ability) { double }
  let(:form)    { CurationConcerns::GenericWorkForm.new(asset, ability) }

  let(:page) do
    view.simple_form_for form do |f|
      render 'curation_concerns/base/form_relationships.html.erb', f: f
    end
    Capybara::Node::Simple.new(rendered)
  end

  before { allow(controller).to receive(:current_user).and_return(user) }

  context "without passing additional relationships" do
    it "displays fields for adding representations and documents" do
      expect(page).not_to have_selector('#generic_work_additional_representation', visible: 'false')
      expect(page).not_to have_selector('#generic_work_additional_document', visible: 'false')
    end
  end

  context "when passing a representation in the url" do
    before { controller.params = { representation_for: 'rep-id', resource_title: "preferred_label" } }
    it "places its id in a hidden field" do
      expect(page).to have_selector('#generic_work_additional_representation', visible: 'false')
      expect(page).to have_selector('p', text: 'This Asset will be added as a representation of CITI resource preferred_label.')
    end
  end

  context "when passing a document in the url" do
    before { controller.params = { document_for: 'doc-id', resource_title: "preferred_label" } }
    it "places its id in a hidden field" do
      expect(page).to have_selector('#generic_work_additional_document', visible: 'false')
      expect(page).to have_selector('p', text: 'This Asset will be added as documentation of CITI resource preferred_label.')
    end
  end

  context "with existing relationships" do
    let(:work)  { SolrDocument.new(build(:work, id: "1234").to_solr) }
    let(:agent) { SolrDocument.new(build(:agent, id: "5678").to_solr) }
    before do
      allow_any_instance_of(HiddenMultiSelectInput).to receive(:render_thumbnail).and_return("thumbnail")
      allow(form).to receive(:document_of_uris).and_return([work])
      allow(form).to receive(:representation_of_uris).and_return([agent])
    end

    it "renders the form" do
      expect(page).to have_selector("input#generic_work_document_of_uris", visible: false)
      expect(page).to have_selector("input#generic_work_representation_of_uris", visible: false)
      expect(page.find("input#generic_work_document_of_uris", visible: false).value).to eq(work.fedora_uri)
      expect(page.find("input#generic_work_representation_of_uris", visible: false).value).to eq(agent.fedora_uri)
    end
  end

  context "without existing attachments" do
    it "displays fields for adding attachments" do
      expect(page).to have_selector('table.attachment_of_uris')
      expect(page).to have_selector('table.attachment_ids')
    end
  end

  context "with existing attachments" do
    let(:asset1) { SolrDocument.new(build(:asset, id: '1', pref_label: "First asset", uid: "uid-1").to_solr) }
    let(:asset2) { SolrDocument.new(build(:asset, id: '2', pref_label: "Second asset").to_solr) }

    before do
      allow_any_instance_of(HiddenMultiSelectInput).to receive(:render_thumbnail).and_return("thumbnail")
      allow(form).to receive(:attachment_of_uris).and_return([asset1, asset2])
      allow(form).to receive(:attachment_ids).and_return([asset1, asset2])
    end

    it "displays the existing uris" do
      expect(page.all("input#generic_work_attachment_of_uris", visible: false).first.value).to eq(asset1.fedora_uri)
      expect(page.all("input#generic_work_attachment_of_uris", visible: false).last.value).to eq(asset2.fedora_uri)
      expect(page.all("input#generic_work_attachment_ids", visible: false).first.value).to eq(asset1.id)
      expect(page.all("input#generic_work_attachment_ids", visible: false).last.value).to eq(asset2.id)
    end
  end
end
