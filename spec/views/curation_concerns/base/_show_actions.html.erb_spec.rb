# frozen_string_literal: true
require 'rails_helper'

describe 'curation_concerns/base/_show_actions.html.erb' do
  let(:asset) { build(:asset, id: '1234', pref_label: 'FineArt') }
  let(:solr_doc) { SolrDocument.new(asset.to_solr) }
  let(:presenter) { AssetPresenter.new(solr_doc, ability) }
  let(:ability) { double }
  let(:page) { Capybara::Node::Simple.new(rendered) }

  subject { page }

  describe "the create lab work button" do
    context "the asset has an imaging number" do
      before do
        allow(ability).to receive(:can?).with(:edit, SolrDocument).and_return(true)
        allow(ability).to receive(:can?).with(:delete, GenericWork).and_return(true)
        allow(presenter).to receive('imaging_uid').and_return(["SI-1234"])
        render 'curation_concerns/base/show_actions.html.erb', presenter: presenter
      end
      it { is_expected.to have_link("Create Lab Work", href: "http://phoenix.artic.edu/order/create/batch/" + presenter.imaging_uid.first.to_s) }
    end

    context "the asset does not have an imaging number" do
      before do
        allow(ability).to receive(:can?).with(:edit, SolrDocument).and_return(true)
        allow(ability).to receive(:can?).with(:delete, GenericWork).and_return(true)
        allow(presenter).to receive('imaging_uid').and_return([])
        render 'curation_concerns/base/show_actions.html.erb', presenter: presenter
      end
      it { is_expected.not_to have_link("Create Lab Work", href: "http://phoenix.artic.edu/order/create/batch/" + presenter.imaging_uid.first.to_s) }
    end
  end
end
