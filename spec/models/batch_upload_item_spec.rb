# frozen_string_literal: true
require 'rails_helper'

describe BatchUploadItem do
  subject { described_class.new }

  describe "#in_collection_ids" do
    its(:in_collection_ids) { is_expected.to be_empty }
  end

  describe "#alt_label" do
    its(:alt_label) { is_expected.to be_empty }
  end
end
