# frozen_string_literal: true
require 'rails_helper'

describe Rails.application.routes do
  it "routes to the reindexing endpoint" do
    expect(post: "/api/reindex").to route_to(controller: "lakeshore/reindex", action: "create")
  end
end
