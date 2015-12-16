require 'rails_helper'

describe HomepageController do
  routes { Sufia::Engine.routes }
  let(:user) { FactoryGirl.find_or_create(:jill) }

  describe "#index" do
    context "with a public user" do
      it "redirects to the login page" do
        get :index
        expect(response).to be_redirect
      end
    end

    context "with a logged in user" do
      before { sign_in user }
      it "sets the number of facet counts for resource type" do
        get :index
        assigns(:resource_types).should_not be_nil
      end
    end
  end
end
