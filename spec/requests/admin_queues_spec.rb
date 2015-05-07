require 'rails_helper'

describe "Resque admin page" do

  context "without a user" do
    it "should not load the page" do
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
