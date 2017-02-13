# frozen_string_literal: true
require 'rails_helper'

describe 'curation_concerns/base/_show_actions.html.erb' do
  let(:ability) { double }
  let(:page)    { Capybara::Node::Simple.new(rendered) }

  before do
    allow(ability).to receive(:can?).with(:edit, SolrDocument).and_return(true)
    allow(ability).to receive(:can?).with(:delete, GenericWork).and_return(true)
    render 'curation_concerns/base/show_actions.html.erb', presenter: presenter
  end

  subject { page }

  context "with an asset" do
    let(:solr_doc)  { SolrDocument.new(asset.to_solr) }
    let(:presenter) { AssetPresenter.new(solr_doc, ability) }

    describe "the create lab work button" do
      context "the asset has an imaging number" do
        let(:asset) { build(:asset, id: '1234', pref_label: 'FineArt', imaging_uid: ["1"]) }

        it { is_expected.to have_link("Create Lab Work", href: "https://phoenix.artic.edu/order/create/batch/1") }
      end

      context "the asset does not have an imaging number" do
        let(:asset) { build(:asset, id: '1234', pref_label: 'FineArt') }

        it { is_expected.not_to have_link("Create Lab Work", href: "https://phoenix.artic.edu/order/create/batch/1") }
      end
    end
  end

  context "with a non-asset" do
    let(:exhibition) { build(:exhibition, id: '1234', pref_label: 'FineArt Exhibit') }
    let(:solr_doc)   { SolrDocument.new(exhibition.to_solr) }
    let(:presenter)  { ExhibitionPresenter.new(solr_doc, ability) }

    it { is_expected.not_to have_link("Create Lab Work") }
  end
end
