# frozen_string_literal: true
require 'rails_helper'

describe BatchEditsController do
  include_context "authenticated saml user"

  let(:destroy_params) do
    {
      method: "delete",
      commit: "delete selected",
      update_type: "delete_all",
      return_controller: "my/works",
      batch_document_ids: [image_asset.id]
    }
  end

  describe "#destroy" do
    context "when the asset has relationships" do
      let!(:image_asset) { create(:still_image_asset, user: user, title: ["Hello Title"]) }
      before do
        allow_any_instance_of(InboundRelationships).to receive(:present?).and_return(true)
        post "destroy_collection", destroy_params
      end

      subject { flash[:error] }

      it { is_expected.to eq("These assets were not deleted because they have resources linking to them: #{image_asset.title.first}.") }
    end

    context "when the asset has no relationships" do
      let!(:image_asset) { create(:still_image_asset, user: user, title: ["Hello Title"]) }
      it "destroys the assets" do
        expect { post "destroy_collection", destroy_params }.to change { GenericWork.count }.by(-1)
      end
    end
  end
end
