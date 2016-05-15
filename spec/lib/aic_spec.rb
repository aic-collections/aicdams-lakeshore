# frozen_string_literal: true
require 'rails_helper'

describe AIC do
  it "has a uri" do
    expect(described_class.to_uri.to_s).to eql("http://definitions.artic.edu/ontology/1.0/")
  end
end
