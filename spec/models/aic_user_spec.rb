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

  describe "::search" do
    before(:all) { create(:aic_user, family_name: "James", given_name: "LeBron", nick: "theking") }
    subject { described_class.search(params).map { |r| r.fetch(:id) } }
    context "with a fuzzy search" do
      let(:params) { "bron" }
      it { is_expected.to contain_exactly("theking") }
    end
    context "with an exact search" do
      let(:params) { "theking" }
      it { is_expected.to contain_exactly("theking") }
    end
    context "with a null search" do
      let(:params) { "asdf" }
      it { is_expected.to be_empty }
    end
  end
end
