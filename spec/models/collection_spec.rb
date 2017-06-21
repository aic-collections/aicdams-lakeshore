# frozen_string_literal: true
require 'rails_helper'

describe Collection do
  describe "::indexer" do
    subject { described_class }
    its(:indexer) { is_expected.to eq(CollectionIndexer) }
  end

  it { is_expected.to respond_to(:title) }
  it { is_expected.to respond_to(:publish_channels) }
  it { is_expected.to respond_to(:publish_channel_uris) }
  it { is_expected.to respond_to(:collection_type) }
  it { is_expected.to respond_to(:collection_type_uri) }
end
