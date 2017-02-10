# frozen_string_literal: true
require 'rails_helper'

describe ApplicationController do
  routes { Rails.application.routes }
  include_context "authenticated saml user"

  before do
    allow(RequestAccessPresenter).to receive(:new).with("1234", "user1").and_return(presenter)
    allow(RequestAccessMailer).to receive(:request_access).with(presenter).and_return(mailer)
    allow(presenter).to receive_messages(title_or_label: "", depositor_full_name: "user1", requester_email: "foo", depositor_email: "user1")
    allow(mailer).to receive_messages(to: "", from: "", subject: "")
    allow(mailer).to receive(:deliver_now)
  end

  describe "#request_access" do
    let(:asset) { create(:department_asset, id: "1234", pref_label: "Sample") }
    let(:presenter) { double }
    let(:mailer) { double }
    it "creates a RequestAccessPresenter instance" do
      expect(RequestAccessPresenter).to receive(:new).with("1234", "user1")

      post :request_access, resource_id: "1234", requester_nick: "user1"
    end

    it "sends an email with RequestAccessMailer" do
      expect(RequestAccessMailer).to receive(:request_access)
      expect(mailer).to receive(:deliver_now)

      post :request_access, resource_id: "1234", requester_nick: "user1"
    end

    it "responds with success msg" do
      post :request_access, resource_id: "1234", requester_nick: "user1"

      expect(flash[:notice]).to eq("user1 has been emailed your request to see this resource.")
      expect(response).to redirect_to("http://test.host/")
    end
  end
end
