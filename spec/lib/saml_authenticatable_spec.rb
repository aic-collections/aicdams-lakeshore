require 'rails_helper'

describe Devise::Strategies::SamlAuthenticatable do
  before { allow_any_instance_of(described_class).to receive(:request).and_return(request) }

  describe "#valid?" do
    subject { described_class.new(nil) }
    context "without an id" do
      let(:request) { double(env: { "HTTP_SAML_PRIMARY_AFFILIATION" => "1" }) }
      let(:request) { double(env: {}) }
      it { is_expected.not_to be_valid }
    end

    context "without a primary affiliation" do
      let(:request) { double(env: {}) }
      let(:request) { double(env: { "HTTP_SAML_UID" => "dude" }) }
      it { is_expected.not_to be_valid }
    end

    context "with the correct SAML variables" do
      let(:request) { double(env: { "HTTP_SAML_UID" => "dude", "HTTP_SAML_PRIMARY_AFFILIATION" => "1" }) }
      it { is_expected.to be_valid }
    end
  end

  describe "#authenticate!" do
    let(:user) { "new_person" }
    let(:department) { "11" }
    let(:request) { double(env: { "HTTP_SAML_UID" => user, "HTTP_SAML_PRIMARY_AFFILIATION" => department }) }
    context "with a first-time user" do
      it "creates new and updates their attributes" do
        expect { described_class.new(nil).authenticate! }.to change { User.all.count }.by(1)
        expect(User.find_by_user_key(user).department).to eq(department)
      end
    end
    context "with a returning user" do
      before { User.create!(email: user, department: department) }
      it "users their existing record" do
        expect(User.find_by_user_key(user)).not_to receive(:save!)
        expect { described_class.new(nil).authenticate! }.to change { User.all.count }.by(0)
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
