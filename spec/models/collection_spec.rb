# frozen_string_literal: true
require 'rails_helper'

describe Collection do
  describe "::indexer" do
    subject { described_class }
    its(:indexer) { is_expected.to eq(CollectionIndexer) }
  end

  it { is_expected.to respond_to(:publish_channels) }
  it { is_expected.to respond_to(:publish_channel_uris) }
end
