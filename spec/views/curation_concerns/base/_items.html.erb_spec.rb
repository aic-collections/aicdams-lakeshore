# frozen_string_literal: true
require 'rails_helper'

describe 'curation_concerns/base/items', verify_partial_doubles: false do
  let(:ability)   { double }
  let(:asset)     { build(:asset, id: 'asset-1') }
  let(:file_set)  { build(:intermediate_file_set) }
  let(:presenter) { AssetPresenter.new(SolrDocument.new(asset.to_solr), ability) }
  let(:member)    { FileSetPresenter.new(SolrDocument.new(file_set.to_solr), ability) }

  let(:blacklight_config) { CatalogController.new.blacklight_config }
  let(:blacklight_configuration_context) do
    Blacklight::Configuration::Context.new(controller)
  end

  before do
    stub_template 'curation_concerns/base/_actions.html.erb' => 'Actions'
    allow(presenter).to receive(:member_presenters).and_return([member])
    allow(view).to receive(:blacklight_config).and_return(Blacklight::Configuration.new)
    allow(view).to receive(:blacklight_configuration_context).and_return(blacklight_configuration_context)
    allow(view).to receive(:contextual_path).and_return("/whocares")
    allow(ability).to receive(:can?).and_return(true)
    render 'curation_concerns/base/items', presenter: presenter
  end

  it "displays the file set's role" do
    expect(rendered).to include('<td class="attribute role">Intermediate File Set</td>')
  end
end
