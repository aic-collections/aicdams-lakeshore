# frozen_string_literal: true
require 'rails_helper'

describe AssetType::StillImage do
  subject { described_class }

  describe "::all" do
    subject { described_class.all }
    it { is_expected.to contain_exactly("application/pdf",
                                        "image/jpeg",
                                        "image/png",
                                        "image/tiff",
                                        "image/jpf",
                                        "image/x-adobe-dng")}
  end

  describe "::types" do
    subject { described_class.types }
    its(:first) { is_expected.to be_kind_of(MIME::Type) }
  end

  describe "#friendly" do
    subject { MIME::Types[type].first.friendly }
    context "with DNG mime types" do
      let(:type) { "image/x-adobe-dng" }
      it { is_expected.to eq("Adobe Digital Negative Raw Image file (DNG)") }
    end
  end
end
