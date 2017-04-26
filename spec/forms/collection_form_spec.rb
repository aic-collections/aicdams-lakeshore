# frozen_string_literal: true
require 'rails_helper'

describe CollectionForm do
  let(:collection) { build(:collection) }
  let(:form) { described_class.new(collection) }

  subject { form }

  it { is_expected.to delegate_method(:depositor).to(:model) }
  it { is_expected.to delegate_method(:dept_created).to(:model) }
  it { is_expected.to delegate_method(:permissions).to(:model) }
end
