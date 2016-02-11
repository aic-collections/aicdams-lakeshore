require 'rails_helper'

describe GenericFilesController do
  routes { Sufia::Engine.routes }
  include_context "authenticated saml user"

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
