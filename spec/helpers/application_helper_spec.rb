# frozen_string_literal: true
require 'rails_helper'
describe ApplicationHelper do
  describe "#env_title_prefix" do
    it "returns LOC: when local environment" do
      f = stub_const("Figaro::ENV", double)
      allow(f).to receive(:HTML_TITLE_PREFIX_ENV) { "local" }
      expect(helper.env_title_prefix).to eq("LOC:")
    end
    it "returns DEV: when develop environment" do
      f = stub_const("Figaro::ENV", double)
      allow(f).to receive(:HTML_TITLE_PREFIX_ENV) { "dev" }
      expect(helper.env_title_prefix).to eq("DEV:")
    end
    it "returns TST: when test environment" do
      f = stub_const("Figaro::ENV", double)
      allow(f).to receive(:HTML_TITLE_PREFIX_ENV) { "test" }
      expect(helper.env_title_prefix).to eq("TST:")
    end
    it "returns STG: when staging environment" do
      f = stub_const("Figaro::ENV", double)
      allow(f).to receive(:HTML_TITLE_PREFIX_ENV) { "staging" }
      expect(helper.env_title_prefix).to eq("STG:")
    end
    it "returns empty string when production environment" do
      f = stub_const("Figaro::ENV", double)
      allow(f).to receive(:HTML_TITLE_PREFIX_ENV) { "production" }
      expect(helper.env_title_prefix).to eq("")
    end
    it "returns empty string if ENV var is not set" do
      f = stub_const("Figaro::ENV", double)
      allow(f).to receive(:HTML_TITLE_PREFIX_ENV) { nil }
      expect(helper.env_title_prefix).to eq("")
    end
  end
end
