# frozen_string_literal: true
require 'rails_helper'

describe AddEditGroupPermissionJob do
  context 'when uid does not exist' do
    let(:job) { described_class.new(uid: 'bogus', group: '100') }

    it 'raises an error' do
      expect { job.perform_now }.to raise_error(ActiveFedora::ObjectNotFoundError)
    end
  end

  context 'when group id does not exist' do
    let(:job) { described_class.new(uid: 'SI-12345678', group: '2') }
    let(:asset) { build(:asset, uid: 'SI-12345678') }

    before { allow(GenericWork).to receive(:find).and_return(asset) }

    it 'raises an error' do
      expect {
        job.perform_now
      }.to raise_error(AddEditGroupPermissionJob::Error, "Department id 2 does not exist")
    end
  end

  context 'when group already has edit access' do
    let(:job) { described_class.new(uid: 'SI-12345678', group: '100') }
    let(:asset) { build(:asset, uid: 'SI-12345678') }

    before { allow(GenericWork).to receive(:find).and_return(asset) }

    it 'does not update the asset' do
      expect(asset).not_to receive(:save)
      expect(job.perform_now).to be_nil
    end
  end

  context 'when adding a new group' do
    let(:job) { described_class.new(uid: 'SI-12345678', group: '200') }
    let(:asset) { build(:asset, uid: 'SI-12345678') }

    before { allow(GenericWork).to receive(:find).and_return(asset) }

    it 'updates the asset' do
      expect(asset).to receive(:save)
      job.perform_now
      expect(asset.edit_groups).to include("200")
    end
  end
end
