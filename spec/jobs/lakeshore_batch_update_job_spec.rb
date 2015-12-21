require 'rails_helper'

describe LakeshoreBatchUpdateJob do
  let(:user) { FactoryGirl.find_or_create(:jill) }
  let(:batch) { Batch.create }

  let!(:file) do
    GenericFile.new(batch: batch) do |file|
      file.apply_depositor_metadata(user)
      file.assert_still_image
      file.save!
    end
  end

  let!(:file2) do
    GenericFile.new(batch: batch) do |file|
      file.apply_depositor_metadata(user)
      file.assert_still_image
      file.save!
    end
  end

  describe "#run" do
    let(:title) { { file.id => ['File One'], file2.id => ['File Two'] } }
    let(:metadata) do
      { read_groups_string: '', read_users_string: 'archivist1, archivist2',
        asset_capture_device: 'Sony camera'
      }.with_indifferent_access
    end

    let(:visibility) { nil }

    let(:job) { described_class.new(user.user_key, batch.id, title, metadata, visibility) }

    describe "updates metadata" do
      before do
        allow(Sufia.queue).to receive(:push)
        job.run
      end

      subject { file.reload }
      its(:title) { is_expected.to eq(['File One']) }
      its(:pref_label) { is_expected.to eq(file.id) }
    end
  end
end
