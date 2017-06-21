# frozen_string_literal: true
require 'rails_helper'

describe CollectionPresenter do
  let(:collection)    { build(:collection, :with_metadata, id: "1234") }
  let(:solr_document) { SolrDocument.new(collection.to_solr) }
  let(:ability)       { Ability.new(nil) }
  let(:presenter)     { described_class.new(solr_document, ability) }

  describe "::terms" do
    subject { described_class }
    its(:terms) { is_expected.to contain_exactly(:total_items, :size, :publish_channels, :collection_type) }
  end

  subject { presenter }

  its(:permission_badge_class) { is_expected.to eq(PermissionBadge) }
  it { is_expected.to delegate_method(:publish_channels).to(:solr_document) }

  describe "#terms_with_values" do
    its(:terms_with_values) { is_expected.to include(:publish_channels) }
  end
end
