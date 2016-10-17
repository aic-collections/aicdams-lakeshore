# frozen_string_literal: true
require 'rails_helper'

describe Lakeshore::APIController do
  # Create an anonymous controller to test the behavior of any controller that inherits from Lakeshore::APIController
  controller do
    def index
      render text: "success"
    end
  end

  before  { routes.draw { get "index" => "lakeshore/api#index" } }
  subject { response }

  context "without a user" do
    before { get :index }
    it { is_expected.to be_unauthorized }
  end

  context "with a user" do
    before do
      sign_in_basic(user)
      get :index
    end

    describe "signing in as an API user" do
      let(:user) { create(:apiuser) }
      it { is_expected.to be_success }
      its(:body) { is_expected.to eq("success") }
    end

    describe "signing in as a non-API user" do
      let(:user) { create(:user1) }
      it { is_expected.to be_unauthorized }
    end

    describe "signing with a user that doesn't exist" do
      let(:user) { double(email: "badguy", password: "thppttt!") }
      it { is_expected.to be_unauthorized }
    end
  end
end
