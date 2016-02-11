require 'rails_helper'

describe RepresentationsController do
  include_context "authenticated saml user"

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
