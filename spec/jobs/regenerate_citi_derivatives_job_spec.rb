# frozen_string_literal: true
require 'rails_helper'

describe RegenerateCitiDerivativesJob do
  let(:file_set)  { create(:file_set) }
  let(:mock_file) { double }
  let(:filename) { "tardis.png" }
  let(:outputs) { [{ label: :citi, format: 'jpg', size: '96x96>', quality: "90", url: "foo" }] }

  it "re-creates the derivatives for an asset" do
    allow_any_instance_of(described_class).to receive(:derivative_url).with(any_args).and_return("foo")

    expect(CurationConcerns::WorkingDirectory).to receive(:find_or_retrieve).with(mock_file, file_set.id, nil).and_return(filename)
    expect(Hydra::Derivatives::ImageDerivatives).to receive(:create).with(filename, outputs: outputs)

    described_class.perform_now(file_set, mock_file)
  end
end
