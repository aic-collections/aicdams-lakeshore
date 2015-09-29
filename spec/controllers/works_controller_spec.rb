require 'rails_helper'

describe WorksController do
  let(:user) { FactoryGirl.find_or_create(:jill) }
  before do
    allow(controller).to receive(:has_access?).and_return(true)
    sign_in user
    allow_any_instance_of(User).to receive(:groups).and_return([])
  end

  let(:work) { Work.create }

  describe "#edit" do
    before { get :edit, id: work }
    subject { response }
    it { is_expected.to be_successful }
  end

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

    context "with a document" do
      let(:document) do
        GenericFile.create.tap do |f|
          f.title = ["Document for a work"]
          f.apply_depositor_metadata user
          f.assert_text
          f.save
        end
      end
      before { post :update, id: work, work: { document_ids: [document.id] } }
      specify do
        expect(response).to be_redirect
        expect(work.reload.document_ids).to contain_exactly(document.id)
      end
    end

    context "with a representation" do
      let(:representation) do
        GenericFile.create.tap do |f|
          f.title = ["Representation of a work"]
          f.apply_depositor_metadata user
          f.assert_still_image
          f.save
        end
      end
      before { post :update, id: work, work: { representation_ids: [representation.id] } }
      specify do
        expect(response).to be_redirect
        expect(work.reload.representation_ids).to contain_exactly(representation.id)
      end    
    end

    context "with a preferred representation" do
      let(:preferred_representation) do
        GenericFile.create.tap do |f|
          f.title = ["Representation of a work"]
          f.apply_depositor_metadata user
          f.assert_still_image
          f.save
        end
      end
      before { post :update, id: work, work: { preferred_representation_ids: [preferred_representation.id] } }
      specify do
        expect(response).to be_redirect
        expect(work.reload.preferred_representation_ids).to contain_exactly(preferred_representation.id)
      end
    end
  end

  describe "#show" do
    before { get :show, id: work }
    subject { response }
    it { is_expected.to be_successful }
  end

  describe "#index" do
    before { get :index }
    subject { response }
    it { is_expected.to be_redirect }
  end

end
