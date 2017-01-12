# frozen_string_literal: true
require 'rails_helper'

describe AICUser do
  describe "intial RDF types" do
    subject { described_class.new.type }
    it { is_expected.to contain_exactly(AICType.AICUser, AICType.Resource, AICType.CitiResource, ::RDF::Vocab::FOAF.Agent) }
  end

  describe "an existing user" do
    subject { build(:aic_user) }
    its(:nick) { is_expected.to eq("joebob") }
    its(:given_name) { is_expected.to eq("Joe") }
    its(:family_name) { is_expected.to eq("Bob") }
  end

  context "using existing records in Fedora and Solr" do
    before(:all) { create(:aic_user, family_name: "James", given_name: "LeBron", nick: "theking") }

    describe "::search" do
      subject { described_class.search(params).map { |r| r.fetch(:id) } }
      context "with a fuzzy search" do
        let(:params) { "bron" }
        it { is_expected.to include("theking") }
      end
      context "with an exact search" do
        let(:params) { "theking" }
        it { is_expected.to include("theking") }
      end
      context "with a null search" do
        let(:params) { "asdf" }
        it { is_expected.to be_empty }
      end
    end

    describe "::find_by_nick" do
      context "with solr" do
        context "using an existing user" do
          subject { described_class.find_by_nick("theking", with_solr: true) }
          its(:nick) { is_expected.to eq("theking") }
        end

        context "when the user doesn't exist" do
          subject { described_class.find_by_nick("zxcv", with_solr: true) }
          it { is_expected.to be_nil }
        end

        context "with a nil nick" do
          subject { described_class.find_by_nick(nil, with_solr: true) }
          it { is_expected.to be_nil }
        end
      end

      context "without solr" do
        subject { described_class.find_by_nick("theking") }
        its(:nick) { is_expected.to eq("theking") }
      end
    end
  end

  describe "::indexer" do
    subject { described_class }
    its(:indexer) { is_expected.to eq(AICUserIndexer) }
  end

  describe "#active?" do
    subject { user }
    context "with an active user" do
      let(:subject) { build(:active_user) }
      it { is_expected.to be_active }
    end

    context "with an inactive user" do
      let(:subject) { build(:inactive_user) }
      it { is_expected.not_to be_active }
    end
  end
end
