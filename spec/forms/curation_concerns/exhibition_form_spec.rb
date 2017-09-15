# frozen_string_literal: true
require 'rails_helper'

describe CurationConcerns::ExhibitionForm do
  subject { described_class }

  its(:model_class) { is_expected.to eq(Exhibition) }
end
