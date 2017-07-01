# frozen_string_literal: true

require 'rails_helper'

describe FileSetPresenter do
  subject { presenter }
  let(:solr_document) { SolrDocument.new(file_set.to_solr) }
  let(:ability)	      { nil }
  let(:presenter)     { described_class.new(solr_document, ability) }

  describe "#permission_badge_class" do
    let(:file_set) { build(:file_set, id: '1234') }
    its(:permission_badge_class) { is_expected.to eq(PermissionBadge) }
  end

  describe "#roles" do
    context "with an intermediate file set" do
      let(:file_set) { build(:intermediate_file_set) }
      its(:role) { is_expected.to contain_exactly(AICType.IntermediateFileSet.label) }
    end

    context "with an original file set" do
      let(:file_set) { build(:original_file_set) }
      its(:role) { is_expected.to contain_exactly(AICType.OriginalFileSet.label) }
    end

    context "with a preservation master file set" do
      let(:file_set) { build(:preservation_file_set) }
      its(:role) { is_expected.to contain_exactly(AICType.PreservationMasterFileSet.label) }
    end

    context "with a legacy file set" do
      let(:file_set) { build(:legacy_file_set) }
      its(:role) { is_expected.to contain_exactly(AICType.LegacyFileSet.label) }
    end

    context "can display image with iiif_manifest data" do
      let(:file_set) { create(:file_set, id: '1234') }
      let(:doc) { { "response" => { "docs" => [{ "id" => "1234", "height_is" => 200, "width_is" => 100 }] } } }
      let(:iiif_manifest) { IIIFManifest::DisplayImage.new("http://hello.com", width: 100, height: 200, iiif_endpoint: iiif_endpoint) }

      it "can return an image's iiif manifest" do
        allow(ActiveFedora::SolrService).to receive(:get).and_return(doc)
        allow(presenter).to receive(:base_image_url).with(file_set.id).and_return("http://hello.com")
        allow(DerivativePath).to receive(:access_path).with(file_set.id).and_return("http://hello.com")
        expect(presenter.display_image).to be_kind_of(IIIFManifest::DisplayImage)
        expect(presenter.display_image.url).to eq("http://hello.com")
        expect(presenter.display_image.width).to eq(100)
        expect(presenter.display_image.height).to eq(200)
        expect(presenter.display_image.iiif_endpoint).to be_kind_of(IIIFManifest::IIIFEndpoint)
        expect(presenter.display_image.iiif_endpoint.profile).to eq("http://iiif.io/api/image/2/level2.json")
        expect(presenter.display_image.iiif_endpoint.url).to eq("http://hello.com")
      end
    end
  end
end
