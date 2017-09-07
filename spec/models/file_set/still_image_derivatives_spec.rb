# frozen_string_literal: true
require 'rails_helper'

describe FileSet do
  let(:file)        { build(:department_file, id: '1234') }
  let(:parent)      { build(:still_image_asset) }
  let(:derivatives) { CurationConcerns::DerivativePath.derivatives_for_reference(file) }

  let(:outputs) do
    [
      {
        label:    :thumbnail,
        format:   "jpg",
        size:     "200x150>",
        url:      "file:#{Rails.root}/tmp/test-derivatives/12/34-thumbnail.jpeg"
      },
      {
        label:    :access,
        format:   "jp2",
        size:     "3000x3000>",
        url:      "file:#{Rails.root}/tmp/test-derivatives/12/34-access.jp2"
      },
      {
        label:    :citi,
        format:   "jpg",
        size:     "96x96>",
        quality:  "90",
        url:      "file:#{Rails.root}/tmp/test-derivatives/12/34-citi.jpg"
      },
      {
        label:    :large,
        format:   "jpg",
        size:     "1024x1024>",
        quality:  "85",
        url:      "file:#{Rails.root}/tmp/test-derivatives/12/34-large.jpg"
      }
    ]
  end

  let(:files) do
    [
      end_with("34-access.jp2"),
      end_with("34-thumbnail.jpeg"),
      end_with("34-citi.jpg"),
      end_with("34-large.jpg")
    ]
  end

  before do
    LakeshoreTesting.reset_derivatives
    allow(file).to receive(:parent).and_return(parent)
  end

  context "with a supported image" do
    let(:image_file) { File.join(fixture_path, "tardis.png") }

    before { allow(file).to receive(:mime_type).and_return("image/png") }

    it "sends the correct parameters" do
      expect(Hydra::Derivatives::FullTextExtract).not_to receive(:create)
      expect(Hydra::Derivatives::ImageDerivatives).to receive(:create).with(image_file, outputs: outputs)
      file.create_derivatives(image_file)
    end

    describe "derivatives", skip: LakeshoreTesting.continuous_integration? do
      subject { derivatives }
      before  { file.create_derivatives(image_file) }
      it { is_expected.to contain_exactly(*files) }
    end
  end

  context "with a pdf image" do
    let(:image_file) { File.join(fixture_path, "test.pdf") }

    before { allow(file).to receive(:mime_type).and_return("application/pdf") }

    it "sends the correct parameters" do
      expect(Hydra::Derivatives::FullTextExtract).not_to receive(:create)
      expect(Hydra::Derivatives::ImageDerivatives).to receive(:create).with(image_file, outputs: outputs)
      file.create_derivatives(image_file)
    end

    describe "derivatives", skip: LakeshoreTesting.continuous_integration? do
      subject { derivatives }
      before  { file.create_derivatives(image_file) }
      it { is_expected.to contain_exactly(*files) }
    end
  end

  context "with an unsupported image" do
    let(:image_file) { File.join(fixture_path, "fake_file.xzy") }

    before { allow(file).to receive(:mime_type).and_return("image/bmp") }

    it "does not create derivatives" do
      expect(Hydra::Derivatives::ImageDerivatives).not_to receive(:create)
      file.create_derivatives(image_file)
    end
  end
end
