# frozen_string_literal: true
require 'rails_helper'

describe RegenerateAssetDerivativesJob do
  let(:file_set)  { create(:file_set) }
  let(:mock_file) { double }
  let(:filename)  { "filename" }

  it "re-creates the derivatives for an asset" do
    expect(CurationConcerns::WorkingDirectory).to receive(:find_or_retrieve).with(mock_file, file_set.id, nil)
      .and_return(filename)
    expect(file_set).to receive(:create_derivatives).with(filename, no_text: true)
    described_class.perform_now(file_set, mock_file)
  end
end
