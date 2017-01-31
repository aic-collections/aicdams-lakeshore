# frozen_string_literal: true
require 'rails_helper'

describe RequestAccessPresenter do
  let(:resource) { create(:department_asset, pref_label: "Sample Label") }
  let(:user) { create(:user1) }
  let(:aic_user) { create(:aic_user) }
  let(:presenter) { described_class.new(resource.id, user) }
  subject { presenter }

  it "creates objects needed by request access mailer" do
    allow(GenericWork).to receive(:find).with(resource.id).and_return(resource)
    allow(AICUser).to receive(:find_by_nick).with(user).and_return(aic_user)
    expect(subject.id).to eq(resource.id)
    expect(subject.requester).to eq(user)
    expect(subject.requester_pretty_name).to eq("Joe Bob")
  end
end
