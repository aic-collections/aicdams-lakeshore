# frozen_string_literal: true
require 'rails_helper'

describe 'curation_concerns/base/show.html.erb' do
  let(:solr_document) { SolrDocument.new(asset.to_solr) }
  let(:ability)       { double }
  let(:presenter)     { AssetPresenter.new(solr_document, ability) }
  let(:page)          { Capybara::Node::Simple.new(rendered) }

  before do
    stub_template 'curation_concerns/base/_metadata.html.erb' => ''
    stub_template 'curation_concerns/base/_relationships.html.erb' => ''
    stub_template 'curation_concerns/base/_show_actions.html.erb' => ''
    stub_template 'curation_concerns/base/_representative_media.html.erb' => ''
    stub_template 'curation_concerns/base/_social_media.html.erb' => ''
    stub_template 'curation_concerns/base/_citations.html.erb' => ''
    stub_template 'curation_concerns/base/_items.html.erb' => ''
    assign(:presenter, presenter)
    render
  end

  context "with a department asset" do
    let(:asset) { build(:department_asset, id: '999', pref_label: 'Department Asset') }
    specify do
      expect(page).to have_selector('span.label-warning', text: "Department")
    end
  end

  context "with a department asset" do
    let(:asset) { build(:registered_asset, id: '999', pref_label: 'Department Asset') }
    specify do
      expect(page).to have_selector('span.label-info', text: "AIC")
    end
  end
end
