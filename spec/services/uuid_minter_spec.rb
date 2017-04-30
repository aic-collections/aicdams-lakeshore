# frozen_string_literal: true
require 'rails_helper'

describe UuidMinter do
  describe "#mint" do
    its(:mint) { is_expected.to match(/[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}/) }
  end
end
