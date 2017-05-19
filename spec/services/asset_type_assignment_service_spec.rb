# frozen_string_literal: true
require 'rails_helper'

describe AssetTypeAssignmentService do
  let(:asset)   { GenericWork.new }
  let(:service) { described_class.new(asset) }

  describe AssetTypeAssignmentService::REGISTRY do
    it { is_expected.to eq(AICType.StillImage => "SI",
                           AICType.Text => "TX",
                           AICType.Dataset => "DS",
                           AICType.MovingImage => "MI",
                           AICType.Sound => "SN",
                           AICType.Archive => "AR")}
  end

  describe "#assign" do
    subject { asset }

    context "with a valid asset type" do
      before { service.assign(AICType.StillImage) }
      its(:type) { is_expected.to include(AICType.StillImage) }
    end

    context "with an invalid asset type" do
      it "raises an error" do
        expect { service.assign(AICType.ListItem) }.to raise_error(ArgumentError, "invalid asset type")
      end
    end

    context "when the asset already has a type" do
      before { service.assign(AICType.StillImage) }
      it "raises an error" do
        expect { service.assign(AICType.Text) }.to raise_error(StandardError, "asset already has a type")
      end
    end
  end

  describe "#prefix" do
    subject { service }

    context "when the asset has a type" do
      before { service.assign(AICType.StillImage) }
      its(:prefix) { is_expected.to eq("SI") }
    end

    context "when the asset has a type" do
      its(:prefix) { is_expected.to be_nil }
    end
  end

  describe "#current_type" do
    subject { service }

    context "with a still image asset" do
      let(:asset) { build(:asset) }
      its(:current_type) { is_expected.to contain_exactly(AICType.StillImage) }
    end

    context "with a text asset" do
      let(:asset) { build(:text_asset) }
      its(:current_type) { is_expected.to contain_exactly(AICType.Text) }
    end

    context "with a dataset asset" do
      let(:asset) { build(:dataset_asset) }
      its(:current_type) { is_expected.to contain_exactly(AICType.Dataset) }
    end

    context "with a moving image asset" do
      let(:asset) { build(:moving_image_asset) }
      its(:current_type) { is_expected.to contain_exactly(AICType.MovingImage) }
    end

    context "with a sound asset" do
      let(:asset) { build(:sound_asset) }
      its(:current_type) { is_expected.to contain_exactly(AICType.Sound) }
    end

    context "with a archive asset" do
      let(:asset) { build(:archive_asset) }
      its(:current_type) { is_expected.to contain_exactly(AICType.Archive) }
    end
  end
end
