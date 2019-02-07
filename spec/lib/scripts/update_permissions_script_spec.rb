# frozen_string_literal: true
require 'rails_helper'

describe UpdatePermissionsScript do
  let(:script) { described_class.new(csv_file: file, group: group) }
  let(:file) { fixture_path + '/edit_department.csv' }
  let(:group) { "6" }

  describe "#check" do
    subject { script.check }

    it { is_expected.to eq("5 assets don't exist") }
  end

  describe "#run" do
    context "when no assets exist" do
      it "does not run any jobs" do
        expect(AddEditGroupPermissionJob).not_to receive(:perform_later)
        script.run
      end
    end

    context "when the assets need the permission change" do
      let(:document) { SolrDocument.new(id: "1", edit_access_group_ssim: ["1"]) }

      before do
        allow(SolrDocument).to receive(:find).and_return(document)
      end

      it "runs a job for each asset" do
        expect(AddEditGroupPermissionJob).to receive(:perform_later).exactly(5).times
        script.run
      end
    end

    context "when the assets do not need the permission change" do
      let(:document) { SolrDocument.new(id: "1", edit_access_group_ssim: ["6"]) }

      before do
        allow(SolrDocument).to receive(:find).and_return(document)
      end

      it "runs no jobs" do
        expect(AddEditGroupPermissionJob).not_to receive(:perform_later)
        script.run
      end
    end
  end
end
