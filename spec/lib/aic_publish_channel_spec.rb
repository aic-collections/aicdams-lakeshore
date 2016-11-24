# frozen_string_literal: true
require 'rails_helper'

describe AICPublishChannel do
  subject { described_class.find_term(uri) }

  describe "retrieving a label with a given uri" do
    let(:uri) { "http://definitions.artic.edu/publish_channel/Web" }
    its(:label) { is_expected.to eq("Web") }
  end

  describe "::options" do
    subject { described_class }
    its(:options) { is_expected.to include("Web" => "http://definitions.artic.edu/publish_channel/Web") }
  end
end
