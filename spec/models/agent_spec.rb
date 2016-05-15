# frozen_string_literal: true
require 'rails_helper'

describe Agent do
  describe "RDF type" do
    subject { described_class.new.type }
    it { is_expected.to include(AICType.Agent, ::RDF::Vocab::FOAF.Agent) }
  end

  describe "terms" do
    subject { described_class.new }
    AgentPresenter.terms.each do |term|
      it { is_expected.to respond_to(term) }
    end
  end

  describe "cardinality" do
    it "limits agent_type to a single value" do
      expect(described_class.properties["agent_type"].multiple?).to be false
    end
  end

  it_behaves_like "a model for a Citi resource"
  it_behaves_like "an unfeatureable model"
end
