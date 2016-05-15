# frozen_string_literal: true
require 'rails_helper'

describe Uid do
  describe "::table_name" do
    subject { described_class.table_name }
    it { is_expected.to eql("tbl_uids") }
  end
end
