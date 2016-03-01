require 'rails_helper'

describe AICUser do
  describe "intial RDF types" do
    subject { described_class.new.type }
    it { is_expected.to include(AICType.User, AICType.CitiResource) }
  end

  describe "an existing user" do
    subject { described_class.find_by_nick("user1") }
    its(:nick) { is_expected.to eq("user1") }
    its(:given_name) { is_expected.to eq("First") }
    its(:family_name) { is_expected.to eq("User") }
    its(:citi_uid) { is_expected.to eq("1") }
    its(:uid) { is_expected.to eq("US-0001") }
    its(:mbox) { is_expected.to eq("user1@artic.edu") }
  end

  describe "::search" do
    subject { described_class.search(params).map { |r| r.fetch(:id) } }
    context "with a fuzzy search" do
      let(:params) { "use" }
      it { is_expected.to contain_exactly("user1", "user2", "admin") }
    end
    context "with an exact search" do
      let(:params) { "admin" }
      it { is_expected.to contain_exactly("admin") }
    end
    context "with a null search" do
      let(:params) { "asdf" }
      it { is_expected.to be_empty }
    end
  end
end
