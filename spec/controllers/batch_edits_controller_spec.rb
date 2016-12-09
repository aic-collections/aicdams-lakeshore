# frozen_string_literal: true
require 'rails_helper'

describe BatchEditsController do
  include_context "authenticated saml user"

  describe "#destroy" do
    context "asset list includes asset with relationships" do
      let(:image_asset) { create(:still_image_asset, user: user, title: ["Hello Title"]) }
      before { image_asset.save! }
      before { allow_any_instance_of(InboundRelationships).to receive(:present?).and_return(true) }

      it "if asset has relationships won't destroy asset and reports that" do
        number_of_works = GenericWork.all.size

        post "destroy_collection", method: "delete", commit: "delete selected", update_type: "delete_all", return_controller: "my/works", batch_document_ids: [image_asset.id]

        expect(flash[:error]).to eq("These assets were not deleted because they have resources linking to them: #{image_asset.title.first}.")
        expect(GenericWork.all.size).to eq number_of_works

        image_asset.destroy unless image_asset.nil?
      end
    end

    context "asset list has no asset with relationships" do
      let(:image_asset) { create(:still_image_asset, user: user, title: ["Hello Title"]) }
      before { image_asset.save! }
      it "destroys the assets and displays success message" do
        number_of_works = GenericWork.all.size
        post "destroy_collection", method: "delete", commit: "delete selected", update_type: "delete_all", return_controller: "my/works", batch_document_ids: [image_asset.id]
        expect(GenericWork.all.size).to eq(number_of_works - 1)
        expect(flash[:notice]).to eq("Batch was successfully deleted.")
      end
    end
  end
end
