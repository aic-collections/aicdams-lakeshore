# frozen_string_literal: true
require 'rails_helper'

describe DimensionsService do
  context "with an image exceeding the maximum" do
    subject { described_class.new(width: 4000, height: 5000) }

    its(:width) { is_expected.to eq(2400) }
    its(:height) { is_expected.to eq(3000) }
  end

  context "with an image within the maximum" do
    subject { described_class.new(width: 400, height: 500) }

    its(:width) { is_expected.to eq(400) }
    its(:height) { is_expected.to eq(500) }
  end

  context "when dimensions are nil" do
    subject { described_class.new(width: nil, height: nil) }

    its(:width) { is_expected.to be_nil }
    its(:height) { is_expected.to be_nil }
  end
end
