require 'rails_helper'

describe DownloadsController do
  routes { Sufia::Engine.routes }

  let(:user) { FactoryGirl.find_or_create(:jill) }
  let(:asset) do
    GenericFile.create do |gf|
      gf.apply_depositor_metadata(user)
      gf.assert_still_image
    end
  end

  before do
    allow(controller).to receive(:has_access?).and_return(true)
    sign_in user
    allow_any_instance_of(User).to receive(:groups).and_return([])
    allow_any_instance_of(FileContentDatastream).to receive(:content).and_return("file content")
    allow_any_instance_of(FileContentDatastream).to receive(:new_record?).and_return(false)
    allow_any_instance_of(FileContentDatastream).to receive(:mime_type).and_return("text/plain")
    allow_any_instance_of(FileContentDatastream).to receive(:size).and_return(1234)
  end

  describe "#show" do
    it "downloads a file's content" do
      get :show, id: asset.id
      expect(response).to be_success
      expect(response.body).to eq("file content")
    end
  end
end
