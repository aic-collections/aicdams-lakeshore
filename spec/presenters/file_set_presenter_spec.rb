# frozen_string_literal: true

require 'rails_helper'

describe FileSetPresenter do
  let(:solr_document) { SolrDocument.new(file_set.to_solr) }
  let(:ability)	      { nil }
  let(:request)       { double }
  let(:presenter)     { described_class.new(solr_document, ability, request) }

  subject { presenter }

  describe "#permission_badge_class" do
    let(:file_set) { build(:file_set, id: '1234') }
    its(:permission_badge_class) { is_expected.to eq(PermissionBadge) }
  end

  describe "#role" do
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
  end

  describe "#display_image" do
    before { allow(request).to receive(:base_url).and_return("/base_url") }

    subject { presenter.display_image }

    context "with an intermediate file set" do
      let(:file_set)      { build(:intermediate_file_set, id: '1234') }
      let(:solr_document) { SolrDocument.new(file_set.to_solr.merge("height_is": 200, "width_is": 100)) }

      before { allow(DerivativePath).to receive(:access_path).with(file_set.id).and_return("http://url") }

      specify do
        is_expected.to be_kind_of(IIIFManifest::DisplayImage)
        expect(subject.url).to eq("http://url")
        expect(subject.width).to eq(100)
        expect(subject.height).to eq(200)
        expect(subject.iiif_endpoint).to be_kind_of(IIIFManifest::IIIFEndpoint)
        expect(subject.iiif_endpoint.url).to eq("http:///base_url/images/1234")
        expect(subject.iiif_endpoint.profile).to eq("http://iiif.io/api/image/2/level2.json")
      end
    end

    context "with an original file set" do
      let(:file_set) { build(:original_file_set, id: '1234') }
      it { is_expected.to be_nil }
    end

    context "when the original exceeds 3000 px" do
      let(:file_set)      { build(:intermediate_file_set, id: 'too-big') }
      let(:solr_document) { SolrDocument.new(file_set.to_solr.merge("height_is": 4000, "width_is": 5000)) }

      specify do
        is_expected.to be_kind_of(IIIFManifest::DisplayImage)
        expect(subject.width).to eq(3000)
        expect(subject.height).to eq(2400)
      end
    end
  end
end
