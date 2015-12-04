require 'rails_helper'

describe BatchEditsController do
  let(:user) { FactoryGirl.find_or_create(:jill) }

  before do
    allow(controller).to receive(:has_access?).and_return(true)
    sign_in user
    allow_any_instance_of(User).to receive(:groups).and_return([])
    allow_any_instance_of(GenericFile).to receive(:characterize)
  end

  let(:image_asset) do
    GenericFile.create do |gf|
      gf.apply_depositor_metadata(user)
      gf.assert_still_image
      gf.save
    end
  end

  describe "#destroy" do
    before { allow_any_instance_of(RepresentingResource).to receive(:representing?).and_return(true) }

    it "reports an error if the asset has resources linking to it" do
      put :update, update_type: "delete_all", return_controller: "my/files", batch_document_ids: [image_asset.id]
      expect(flash[:error]).to eq("Some assets were not deleted because they have resources linking to them")
    end
  end
end
