require 'rails_helper'

describe GenericFilesController do
  routes { Sufia::Engine.routes }
  include_context "authenticated saml user"

  let(:generic_file) { create(:still_image_asset, user: user) }

  describe "setting the status to disabled" do
    let(:status) { create(:status_type, pref_label: "disabled") }
    let(:attributes) do
      { status_id: status.id }
    end
    before { post :update, id: generic_file, generic_file: attributes }
    subject { generic_file.reload }
    its(:status) { is_expected.to eq(status) }
  end
end
