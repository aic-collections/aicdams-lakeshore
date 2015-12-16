require 'rails_helper'

describe GenericFilesController do
  routes { Sufia::Engine.routes }
  let(:user) { FactoryGirl.find_or_create(:jill) }
  before do
    allow(controller).to receive(:has_access?).and_return(true)
    sign_in user
    allow_any_instance_of(User).to receive(:groups).and_return([])
    allow_any_instance_of(GenericFile).to receive(:characterize)
  end

  let(:generic_file) do
    GenericFile.create do |gf|
      gf.apply_depositor_metadata(user)
      gf.assert_still_image
    end
  end

  describe "setting the status to disabled" do
    let(:attributes) do
      { status_id: StatusType.disabled.id }
    end
    before { post :update, id: generic_file, generic_file: attributes }
    subject { generic_file.reload }
    it { is_expected.to be_disabled }
  end
end
