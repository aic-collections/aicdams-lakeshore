require 'rails_helper'

describe LakeshoreBatchUpdateJob do
  let(:user) { create(:user1) }
  let(:batch) { Batch.create }

  let!(:file)  { create(:still_image_asset, user: user, batch: batch) }
  let!(:file2) { create(:still_image_asset, user: user, batch: batch) }

  let(:work)  { Work.create }
  let(:actor) { Actor.create }
  let(:type)  { create(:list_item) }

  describe "#run" do
    let(:title) { { file.id => ['File One'], file2.id => ['File Two'] } }
    let(:metadata) do
      { read_groups_string: '', read_users_string: 'archivist1, archivist2',
        asset_capture_device: 'Sony camera',
        document_type_ids: ["", type.id],
        representation_for: work.id,
        document_for: actor.id
      }.with_indifferent_access
    end

    let(:visibility) { nil }

    let(:job) { described_class.new(user.user_key, batch.id, title, metadata, visibility) }

    before do
      allow(Sufia.queue).to receive(:push)
      job.run
      file.reload
      file2.reload
      work.reload
      actor.reload
    end

    it "updates the metadata for each file" do
      expect(file.title).to eq(['File One'])
      expect(file2.title).to eq(['File Two'])
      expect(file.pref_label).to eq(file.id)
      expect(file2.pref_label).to eq(file2.id)
      expect(file.document_type).to contain_exactly(type)
      expect(file2.document_type).to contain_exactly(type)
      expect(file.asset_capture_device).to eq("Sony camera")
      expect(file2.asset_capture_device).to eq("Sony camera")
      expect(work.representation_ids).to contain_exactly(file.id, file2.id)
      expect(actor.document_ids).to contain_exactly(file.id, file2.id)
    end
  end
end
