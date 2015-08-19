require 'rails_helper'

describe HomepageController do

  describe "#index" do

    it "sets the number of facet counts for resource type" do
      get :index
      assigns(:resource_types).should_not be_nil
    end

  end

end
