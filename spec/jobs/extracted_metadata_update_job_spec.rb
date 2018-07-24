# frozen_string_literal: true
require 'rails_helper'

describe ExtractedMetadataUpdateJob do
  describe 'updating the created property on an asset' do
    before do
      allow(file_set).to receive(:parent).and_return(asset)
    end

    context 'when the property already as a value' do
      let(:asset) { build(:asset, created: 'today') }
      let(:file_set) { build(:file_set) }

      it 'does not update the property' do
        expect(CreateDerivativesJob).to receive(:perform_later).with(file_set, nil, nil)
        expect(asset.created).to eq('today')
        described_class.perform_now(file_set)
        expect(asset.created).to eq('today')
      end
    end

    context 'when an original file set is present' do
      let(:asset) { build(:asset) }
      let(:file_set) { build(:original_file_set) }
      let(:file) { instance_double(Hydra::PCDM::File, date_created: ["2018:05:18 10:24:45"]) }

      before do
        allow(file_set).to receive(:original_file).and_return(file)
      end

      it 'prefers the original over the intermediate' do
        expect(CreateDerivativesJob).to receive(:perform_later).with(file_set, nil, nil)
        expect(asset.created).to be_nil
        described_class.perform_now(file_set)
        expect(asset.created).to eq("2018:05:18 10:24:45")
      end
    end

    context 'when an intermediate file set is present' do
      let(:asset) { build(:asset) }
      let(:file_set) { build(:intermediate_file_set) }
      let(:file) { instance_double(Hydra::PCDM::File, date_created: ["2018:05:18 10:24:45"]) }

      before do
        allow(file_set).to receive(:original_file).and_return(file)
      end

      it 'updates the property' do
        expect(CreateDerivativesJob).to receive(:perform_later).with(file_set, nil, nil)
        expect(asset.created).to be_nil
        described_class.perform_now(file_set)
        expect(asset.created).to eq("2018:05:18 10:24:45")
      end
    end

    context 'when neither original nor intermediate are present' do
      let(:asset) { build(:asset) }
      let(:file_set) { build(:preservation_file_set) }
      let(:file) { instance_double(Hydra::PCDM::File, date_created: ["2018:05:18 10:24:45"]) }

      before do
        allow(file_set).to receive(:original_file).and_return(file)
      end

      it 'does not update the property' do
        expect(CreateDerivativesJob).to receive(:perform_later).with(file_set, nil, nil)
        expect(asset.created).to be_nil
        described_class.perform_now(file_set)
        expect(asset.created).to be_nil
      end
    end

    context 'when the original_file has no created date' do
      let(:asset) { build(:asset) }
      let(:file_set) { build(:preservation_file_set) }
      let(:file) { instance_double(Hydra::PCDM::File) }

      before do
        allow(file_set).to receive(:original_file).and_return(file)
      end

      it 'does not save the asset' do
        expect(CreateDerivativesJob).to receive(:perform_later).with(file_set, nil, nil)
        expect(asset).not_to receive(:save)
        expect(asset.created).to be_nil
        described_class.perform_now(file_set)
        expect(asset.created).to be_nil
      end
    end

    context 'when there is no original file' do
      let(:asset) { build(:asset) }
      let(:file_set) { build(:original_file_set) }

      it 'raises an error' do
        expect(asset.created).to be_nil
        expect { described_class.perform_now(file_set) }.to raise_error(Lakeshore::JobError)
      end
    end
  end
end
