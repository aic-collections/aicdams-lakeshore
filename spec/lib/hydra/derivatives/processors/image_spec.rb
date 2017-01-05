# frozen_string_literal: true
require 'rails_helper'
require 'open3'

describe Hydra::Derivatives::Processors::Image do
  include Open3
  let(:file_name) { "file_name" }
  subject { described_class.new(file_name, directives) }

  describe "#process and perform conversion operations" do
    let(:mock_image) { double("MockImage") }
    let(:directives) { { label: :access, size: "3000x3000>", format: 'jp2', url: "file:#{Rails.root}/tmp/derivatives/r-access.jp2" } }

    context "psd" do
      before { allow(subject).to receive(:load_image_transformer).and_return(mock_image) }
      it "resizes, formats and flattens psd files" do
        allow(mock_image).to receive(:type).and_return("psd")
        expect(mock_image).not_to receive(:layers)
        expect(mock_image).to receive(:flatten)
        expect(mock_image).to receive(:resize).with("3000x3000>")
        expect(mock_image).to receive(:format).with("jp2")
        expect(subject).to receive(:write_image).with(mock_image)
        subject.process
      end
    end

    context "pdf" do
      before { allow(subject).to receive(:load_image_transformer).and_return(mock_image) }
      # pdf access masters are simply copies of the original
      it "does not resize, format or flatten pdf access files" do
        allow(mock_image).to receive(:type).and_return("pdf")
        expect(mock_image).not_to receive(:layers)
        expect(mock_image).not_to receive(:flatten)
        expect(mock_image).not_to receive(:resize)
        expect(mock_image).not_to receive(:format)
        expect(subject).not_to receive(:write_image)
        subject.process
      end
    end
  end

  describe "#process and run shell commands" do
    context "the mogrify command runs", unless: LakeshoreTesting.continuous_integration? do
      let(:directives) { { label: :access, format: "jp2", size: "3000x3000>", url: "file:#{Rails.root}/tmp/derivatives/s-access.jp2" } }
      let(:file_name) { File.join(fixture_path, "tardis.png") }
      it "converts the image" do
        expect(described_class).to receive(:execute).with("#{ENV['hydra_bin_path']}mogrify #{Rails.root}/tmp/derivatives/s-access.jp2")
        subject.process

        _stdin, _stdout, _stderr = popen3("rm -rf #{Rails.root}/tmp/derivatives/s-access.jp2")
      end
    end
  end
end
