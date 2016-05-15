# frozen_string_literal: true
require 'rails_helper'

describe SolrDocument do
  describe "visibility" do
    context "by default" do
      its(:public?) { is_expected.to be false }
      its(:private?) { is_expected.to be false }
      its(:department?) { is_expected.to be true }
    end
    context "when registered" do
      before { subject["read_access_group_ssim"] = ["registered"] }
      its(:department?) { is_expected.to be false }
      its(:registered?) { is_expected.to be true }
    end
  end

  describe "#uid" do
    before { subject[Solrizer.solr_name("uid", :symbol)] = "UID" }
    its(:uid) { is_expected.to eq("UID") }
  end

  describe "#main_ref_number" do
    before { subject[Solrizer.solr_name("main_ref_number", :stored_searchable)] = "Main ref number" }
    its(:main_ref_number) { is_expected.to eq("Main ref number") }
  end
end
