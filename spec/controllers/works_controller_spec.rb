require 'rails_helper'

describe WorksController do
  let(:user) { FactoryGirl.find_or_create(:jill) }
  before do
    allow(controller).to receive(:has_access?).and_return(true)
    sign_in user
    allow_any_instance_of(User).to receive(:groups).and_return([])
  end

  let(:work) { Work.create }

  let(:asset) do
    GenericFile.create.tap do |f|
      f.title = ["Asset in a work"]
      f.apply_depositor_metadata user
      f.save
    end
  end

  describe "#edit" do
    before { get :edit, id: work }
    subject { response }
    it { is_expected.to be_successful }
  end

  describe "#update" do
    before { post :update, id: work, work: { asset_ids: [asset.id] } }
    specify do
      expect(response).to be_redirect
      expect(work.reload.asset_ids).to contain_exactly(asset.id)
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
