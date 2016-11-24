# frozen_string_literal: true
require 'rails_helper'

describe PublishChannel do
  subject { described_class.new(uri) }

  context "with a vocab term" do
    let(:uri) { AICPublishChannel.TrustedParty }
    its(:uri) { is_expected.to eq("http://definitions.artic.edu/publish_channel/TrustedParty") }
    its(:pref_label) { is_expected.to eq("Trusted Party") }
  end
end
