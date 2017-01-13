# frozen_string_literal: true
require 'rails_helper'

describe Rails do
  it "uses Figaro to manage environment variables" do
    expect(ENV['sample_variable']).to eq("foo")
  end
end
