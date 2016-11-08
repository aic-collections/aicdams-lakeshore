# frozen_string_literal: true
require 'rails_helper'

describe DerivativePath do
  let(:asset) { build(:file_set, id: "11aa22bb3") }

  describe "::derivative_path_for_reference" do
    subject { described_class.derivative_path_for_reference(asset, destination_name) }

    context "with a thumbnail" do
      let(:destination_name) { "thumbnail" }
      it { is_expected.to end_with("11/aa/22/bb/3-thumbnail.jpeg") }
    end

    context "with a CITI thumbnail" do
      let(:destination_name) { "citi" }
      it { is_expected.to end_with("11/aa/22/bb/3-citi.jpg") }
    end

    context "with an access image master" do
      let(:destination_name) { "access" }
      it { is_expected.to end_with("11/aa/22/bb/3-access.jp2") }
    end

    context "with an access document master" do
      let(:destination_name) { "document" }
      it { is_expected.to end_with("11/aa/22/bb/3-access.pdf") }
    end

    context "with a large CITI derivative" do
      let(:destination_name) { "large" }
      it { is_expected.to end_with("11/aa/22/bb/3-large.jpg") }
    end
  end

  describe "::access_path" do
    let(:service) { described_class.new(asset) }

    subject { service.access_path }

    context "with no access file" do
      it { is_expected.to be_nil }
    end

    context "with an access path" do
      let(:pathname) { Pathname.new("11/aa/22/bb/3-access.jp2") }
      before { allow(service).to receive(:all_paths).and_return([pathname]) }
      it { is_expected.to eq(pathname) }
    end
  end
end
