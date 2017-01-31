# frozen_string_literal: true
require 'rails_helper'

describe "shared/_request_access.html.erb" do
  let(:asset)  { create(:department_asset, id: "1234", pref_label: "Sample") }
  let(:user) { create(:user1) }
  let(:presenter) { double }
  let(:page) { Capybara::Node::Simple.new(rendered) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
    allow(presenter).to receive(:id).and_return("1234")
    allow(presenter).to receive(:depositor).and_return("Joe Bob")
    allow(presenter).to receive(:title_or_label).and_return("Sample")

    render "shared/request_access.html.erb", presenter: presenter
  end

  it "renders a form with resource and requester values" do
    expect(page.find("#resource_id", visible: false).value).to eq("1234")
    expect(page.find("#requester_nick", visible: false).value).to eq("user1")
  end
end
