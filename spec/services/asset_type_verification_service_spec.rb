# frozen_string_literal: true
require 'rails_helper'

describe AssetTypeVerificationService do
  subject { described_class.call(file, asset_type) }

  describe "still images" do
    let(:asset_type) { AICType.StillImage }

    context "with a valid still image" do
      ["pdf", "jpeg", "png", "tiff", "jpf", "dng"].each do |ext|
        it "registers the #{ext} extension" do
          expect(described_class.call(double(original_filename: "good.#{ext}"), asset_type)).to be true
        end
      end
    end

    context "when invalid" do
      let(:file) { double(original_filename: "bad.txt") }
      it { is_expected.to be false }
    end
  end

  describe "text files" do
    let(:asset_type) { AICType.Text }

    context "with a valid text file" do
      let(:file) { double(original_filename: "good.txt") }
      it { is_expected.to be true }
    end

    context "with an invalid text file" do
      let(:file) { double(original_filename: "bad.gif") }
      it { is_expected.to be false }
    end
  end

  describe "datasets" do
    let(:asset_type) { AICType.Dataset }

    context "with a valid dataset" do
      ["xml", "json", "fp7", "fp12", "xls", "xlsx", "ods", "csv", "tsv", "twbx"].each do |ext|
        it "registers the #{ext} extension" do
          expect(described_class.call(double(original_filename: "good.#{ext}"), asset_type)).to be true
        end
      end
    end

    context "with an invalid dataset" do
      let(:file) { double(original_filename: "bad.gif") }
      it { is_expected.to be false }
    end
  end

  describe "archive files" do
    let(:asset_type) { AICType.Archive }

    context "with a valid archive" do
      ["7z", "bz2", "tar", "tgz", "tar.gz", "gz", "xz", "zip"].each do |ext|
        it "registers the #{ext} extension" do
          expect(described_class.call(double(original_filename: "good.#{ext}"), asset_type)).to be true
        end
      end
    end

    context "with an invalid archive" do
      let(:file) { double(original_filename: "bad.gif") }
      it { is_expected.to be false }
    end
  end

  describe "sound files" do
    let(:asset_type) { AICType.Sound }

    context "with a valid sound file" do
      ["aac", "aiff", "mp3", "mp4", "m4a", "wav"].each do |ext|
        it "registers the #{ext} extension" do
          expect(described_class.call(double(original_filename: "good.#{ext}"), asset_type)).to be true
        end
      end
    end

    context "with an invalid sound file" do
      let(:file) { double(original_filename: "bad.gif") }
      it { is_expected.to be false }
    end
  end

  describe "moving images" do
    let(:asset_type) { AICType.MovingImage }

    context "with a valid moving image" do
      ["3gp", "3g2", "gif", "mp4", "mov", "webm", "flv", "f4v", "f4p", "f4a", "f4b", "avi", "wmv", "mts"].each do |ext|
        it "registers the #{ext} extension" do
          expect(described_class.call(double(original_filename: "good.#{ext}"), asset_type)).to be true
        end
      end
    end

    context "with an invalid moving image" do
      let(:file) { double(original_filename: "bad.wav") }
      it { is_expected.to be false }
    end
  end
end
