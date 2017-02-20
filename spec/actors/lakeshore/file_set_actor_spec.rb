# frozen_string_literal: true
require 'rails_helper'

describe Lakeshore::Actors::FileSetActor do
  let(:user)     { create(:user) }
  let(:file_set) { build(:file_set) }

  subject { described_class.new(file_set, user) }
  its(:file_actor_class) { is_expected.to eq(Lakeshore::Actors::FileActor) }
end
