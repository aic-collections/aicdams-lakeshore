require 'rails_helper'

describe RepresentationsController do
  let(:user) { FactoryGirl.find_or_create(:jill) }
  before do
    allow(controller).to receive(:has_access?).and_return(true)
    sign_in user
    allow_any_instance_of(User).to receive(:groups).and_return([])
  end

  describe "#index" do
    context "with a successful request" do
      subject { get :index, model: "Work", citi_uid: "43523" }
      it { is_expected.to be_success }
    end
    context "with an unsuccessful request" do
      subject { get :index, model: "Actor", citi_uid: "1234" }
      it { is_expected.to be_not_found }
    end
  end
end
