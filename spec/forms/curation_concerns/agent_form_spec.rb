# frozen_string_literal: true
require 'rails_helper'

describe CurationConcerns::AgentForm do
  subject { described_class }

  its(:model_class) { is_expected.to eq(Agent) }
end
