require 'rails_helper'

describe BatchController do
  subject { described_class }
  its(:edit_form_class) { is_expected.to eq(AssetBatchEditForm) }

  routes { Sufia::Engine.routes }
  let(:user) { FactoryGirl.find_or_create(:jill) }
  before do
    sign_in user
    allow_any_instance_of(User).to receive(:groups).and_return([])
  end
  describe "#update" do
    let(:batch_update_message) { double('batch update message') }
    let(:batch) { Batch.create }
    context "en-queuing a batch job" do
      it "is successful" do
        expect(LakeshoreBatchUpdateJob).to receive(:new).with(
          user.user_key,
          batch.id,
          { '1' => 'foo' },
          { document_type_ids: DocumentType.all.map(&:id) },
          'open'
        ).and_return(batch_update_message)
        expect(Sufia.queue).to receive(:push).with(batch_update_message).once
        post :update, id: batch.id, title: { '1' => 'foo' }, visibility: 'open', generic_file: { document_type_ids: DocumentType.all.map(&:id) }
        expect(assigns(:batch_update_job)).to eq(batch_update_message)
        expect(response).to redirect_to routes.url_helpers.dashboard_files_path
        expect(flash[:notice]).to include("Your files are being processed")
      end
    end
  end
end
