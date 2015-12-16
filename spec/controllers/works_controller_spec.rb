require 'rails_helper'

describe WorksController do
  it_behaves_like "a controller for a Citi resource", "work"

  let(:user) { FactoryGirl.find_or_create(:jill) }
  before do
    allow(controller).to receive(:has_access?).and_return(true)
    sign_in user
    allow_any_instance_of(User).to receive(:groups).and_return([])
  end

  let(:work) { Work.create }

  describe "#update" do
    context "with an asset" do
      let(:asset) do
        GenericFile.create.tap do |f|
          f.title = ["Asset in a work"]
          f.apply_depositor_metadata user
          f.assert_still_image
          f.save
        end
      end
      before { post :update, id: work, work: { asset_ids: [asset.id] } }
      specify do
        expect(response).to be_redirect
        expect(work.reload.asset_ids).to contain_exactly(asset.id)
      end
    end
  end
end
