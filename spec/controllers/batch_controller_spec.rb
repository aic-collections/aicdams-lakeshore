require 'rails_helper'

describe BatchController do
  describe "#edit_form_class" do
    its(:edit_form_class) { is_expected.to eq(AssetBatchEditForm) }
  end

  describe "#update" do
    let(:batch_update_message) { double('batch update message') }
    let(:batch) { Batch.create }
    let(:type) { create(:list_item) }

    let(:parameters) do
      {
        document_type_ids: [type.id],
        representation_for: "xxxx",
        document_for: "yyyyy"
      }
    end

    routes { Sufia::Engine.routes }
    include_context "authenticated saml user"

    context "en-queuing a batch job" do
      it "is successful" do
        expect(LakeshoreBatchUpdateJob).to receive(:new).with(
          user.user_key,
          batch.id,
          { '1' => 'foo' },
          parameters,
          'open'
        ).and_return(batch_update_message)
        expect(Sufia.queue).to receive(:push).with(batch_update_message).once
        post :update, id: batch.id, title: { '1' => 'foo' }, visibility: 'open', generic_file: parameters
        expect(assigns(:batch_update_job)).to eq(batch_update_message)
        expect(response).to redirect_to routes.url_helpers.dashboard_files_path
        expect(flash[:notice]).to include("Your files are being processed")
      end
    end
  end
end
