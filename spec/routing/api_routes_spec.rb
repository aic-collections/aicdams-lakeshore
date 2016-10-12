# frozen_string_literal: true
require 'rails_helper'

describe Rails.application.routes do
  context "when using the API" do
    it "routes to the reindexing endpoint" do
      expect(post: "/api/reindex").to route_to(controller: "lakeshore/reindex", action: "create", format: :json)
    end

    it "routes to the downloads" do
      expect(get: "/api/downloads/filesetid").to route_to(controller: "lakeshore/downloads",
                                                          action: "show",
                                                          format: :json,
                                                          id: "filesetid")
    end
  end
end
