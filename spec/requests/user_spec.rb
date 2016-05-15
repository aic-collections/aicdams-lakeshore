# frozen_string_literal: true
require 'rails_helper'

describe "User" do
  describe "sign_up" do
    before { get("/users/sign_up") }
    it "is not allowed" do
      expect(response).to be_redirect
    end
  end
end
