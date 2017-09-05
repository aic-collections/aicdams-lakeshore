# frozen_string_literal: true
require 'rails_helper'

describe FileSet do
  let(:file) { build(:department_file, id: '1234') }

  subject { file }

  describe "#id" do
    let(:file) { create(:department_file) }
    its(:id) { is_expected.to match(/[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}/) }
  end
end
