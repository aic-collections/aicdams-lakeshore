# frozen_string_literal: true
require 'rails_helper'

describe AclService do
  let(:asset)    { build(:asset) }
  let(:file_set) { build(:file_set) }
  let(:service)  { described_class.new(asset) }

  before do
    allow(asset).to receive(:file_sets).and_return([file_set])
  end

  describe "#update" do
    context "when the acls do not match" do
      it "re-indexes an assets file sets" do
        expect(asset).to receive(:update_index)
        expect(file_set).to receive(:update_index)
        service.update
        expect(file_set.access_control_id).to eq(asset.access_control_id)
      end
    end

    context "when the acls match" do
      before { allow(service).to receive(:matching_acls?).with(file_set).and_return(true) }

      it "re-indexes an assets file sets" do
        expect(asset).to receive(:update_index)
        expect(file_set).to receive(:update_index)
        expect(file_set).not_to receive(:save)
        service.update
      end
    end
  end
end
