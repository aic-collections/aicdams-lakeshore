require 'rails_helper'

describe WorksController do
  it_behaves_like "a controller for a Citi resource", "work"

  include_context "authenticated saml user"
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
