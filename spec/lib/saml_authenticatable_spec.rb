# frozen_string_literal: true
require 'rails_helper'

describe Devise::Strategies::SamlAuthenticatable do
  before { allow_any_instance_of(described_class).to receive(:request).and_return(request) }

  describe "#valid?" do
    subject { described_class.new(nil) }
    context "without an id" do
      let(:request) { double(env: { "HTTP_SAML_PRIMARY_AFFILIATION" => "100" }) }
      it { is_expected.not_to be_valid }
    end

    context "without a primary affiliation" do
      let(:request) { double(env: { "HTTP_SAML_UID" => "user1" }) }
      it { is_expected.not_to be_valid }
    end

    context "when the id is not an AICUser" do
      let(:request) { double(env: { "HTTP_SAML_UID" => "dude", "HTTP_SAML_PRIMARY_AFFILIATION" => "100" }) }
      it { is_expected.not_to be_valid }
    end

    context "when the primary affiliation is not a Department" do
      let(:request) { double(env: { "HTTP_SAML_UID" => "user1", "HTTP_SAML_PRIMARY_AFFILIATION" => "13" }) }
      it { is_expected.not_to be_valid }
    end

    context "with the correct SAML variables and an AICUser" do
      let(:request) { double(env: { "HTTP_SAML_UID" => "user1", "HTTP_SAML_PRIMARY_AFFILIATION" => "100" }) }
      it { is_expected.to be_valid }
    end

    context "when logging an authentication failure" do
      let(:request) { double(env: { "HTTP_SAML_UNSCOPED_AFFILIATION" => "something" }) }
      specify do
        expect(Rails.logger).to receive(:error).with(/One or more required credentials are missing/)
        described_class.new(nil).valid?
      end
    end
  end

  describe "#report" do
    let(:request) { double(env: { "HTTP_SAML_UNSCOPED_AFFILIATION" => "something" }) }
    subject { described_class.new(nil).report }

    it do
      is_expected.to contain_exactly(
        "AIC department (required): --missing--",
        "AIC user (required): --missing--",
        "HTTP_SAML_PRIMARY_AFFILIATION (required): --missing--",
        "HTTP_SAML_UID (required): --missing--",
        "HTTP_SAML_UNSCOPED_AFFILIATION: something"
      )
    end
  end

  describe "#authenticate!" do
    context "when the user is present in Lake" do
      let(:user) { "user1" }
      let(:department) { "100" }
      let(:request) { double(env: { "HTTP_SAML_UID" => user, "HTTP_SAML_PRIMARY_AFFILIATION" => department }) }
      context "logging in for the first time" do
        it "creates a new record" do
          expect { described_class.new(nil).authenticate! }.to change { User.all.count }.by(1)
          expect(User.find_by_user_key(user).department).to eq(department)
        end
      end
      context "returning again" do
        before { User.create!(email: user, department: department) }
        it "uses their existing record" do
          expect(User.find_by_user_key(user)).not_to receive(:save!)
          expect { described_class.new(nil).authenticate! }.to change { User.all.count }.by(0)
        end
      end
    end
  end

  describe "#saml_groups" do
    subject { described_class.new(nil).saml_groups }
    context "with no affiliations" do
      let(:request) { double(env: { "HTTP_SAML_UID" => "dude", "HTTP_SAML_PRIMARY_AFFILIATION" => "1" }) }
      it { is_expected.to be_empty }
    end
    context "with affiliations" do
      let(:request) { double(env: { "HTTP_SAML_UNSCOPED_AFFILIATION" => "12;13" }) }
      it { is_expected.to contain_exactly("12", "13") }
    end
  end
end
