# frozen_string_literal: true
require 'rails_helper'

describe Collection do
  describe "::indexer" do
    subject { described_class }
    its(:indexer) { is_expected.to eq(CollectionIndexer) }
  end
end
