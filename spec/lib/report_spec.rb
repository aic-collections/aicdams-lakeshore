# frozen_string_literal: true
require 'rails_helper'

describe Report do
  it "runs the jobs to remove and update duplicate assets" do
    report = described_class.new(Pathname.new(fixture_path).join('sample-report.csv'))
    report.call
  end
end
