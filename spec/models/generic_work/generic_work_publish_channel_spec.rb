# frozen_string_literal: true
require 'rails_helper'

describe GenericWork do
  let(:asset) { build(:asset) }
  let(:uri)   { "http://definitions.artic.edu/publish_channel/Web" }

  subject { asset }

  context "when adding a publish channel to an asset" do
    before do
      asset.publish_channel_uris = [uri]
      asset.save
      asset.reload
    end

    its(:publish_channel_uris) { is_expected.to contain_exactly(uri) }
    its(:to_solr) { is_expected.to include("publish_channels_ssim" => ["Web"]) }
  end
end
