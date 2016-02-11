require 'rails_helper'

describe "Admininistrative" do
  describe "resque functions" do
    context "without a user" do
      it "does not load the page" do
        expect { get "/admin/queues" }.to raise_error(ActionController::RoutingError)
      end
    end

    context "with a user" do
      before { allow(ResqueAdmin).to receive("matches?").and_return(true) }
      it "loads the page" do
        get "/admin/queues"
      end
    end
  end

  describe "role management" do
    context "without a user" do
      before { get "/admin/roles" }
      it "does not load the page" do
        expect(response).to be_unauthorized
      end
    end
  end
end
