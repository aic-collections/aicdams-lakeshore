# frozen_string_literal: true
require 'rails_helper'

describe AgentPresenter do
  let(:agent)   { build(:agent, id: '1234') }
  let(:ability) { Ability.new(nil) }

  subject { described_class.new(agent.to_solr, ability) }

  it { is_expected.to delegate_method(:uid).to(:solr_document) }
  it { is_expected.not_to be_deleteable }
end
