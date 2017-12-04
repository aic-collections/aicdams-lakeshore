# frozen_string_literal: true
require 'rails_helper'

describe GenericWork do
  let(:user)         { create(:user1) }
  let(:example_file) { create(:asset) }

  subject { described_class.new }

  describe "::human_readable_type" do
    subject { described_class.human_readable_type }
    it { is_expected.to eq("Asset") }
  end

  context "without setting a type" do
    subject { build(:asset_without_type) }
    it "raises and error" do
      expect(-> { subject.save }).to raise_error(ArgumentError, "Can't mint a UID without a prefix")
    end
  end

  describe "initial RDF types" do
    subject { described_class.new.type }
    it { is_expected.to include(AICType.Asset, AICType.Resource) }
  end

  describe "asserting StillImage" do
    subject { build(:asset) }

    specify { expect(subject.type).to include(AICType.Asset, AICType.StillImage) }

    describe "#to_solr" do
      let(:keyword) { create(:list_item) }

      before do
        allow(subject).to receive(:id).and_return('fake-id')
        subject.keyword = [keyword.uri]
      end

      it "contains our custom solr fields" do
        expect(subject.to_solr[Solrizer.solr_name("aic_type", :facetable)]).to include("Asset", "Still Image")
        expect(subject.to_solr[Solrizer.solr_name("keyword", :facetable)]).to contain_exactly(keyword.pref_label)
        expect(subject.to_solr[Solrizer.solr_name("keyword", :stored_searchable)]).to contain_exactly(keyword.pref_label)
      end
    end

    describe "minting uids" do
      let(:hash)  { Digest::MD5.hexdigest(subject.uid) }
      let(:dhash) { [hash[0, 8], hash[8, 4], hash[12, 4], hash[16, 4], hash[20..-1]].join('-') }

      before { subject.save }

      it "uses a checksum as a path" do
        expect(subject.id).to match(/^\h{8}-\h{4}-\h{4}-\h{4}-\h{12}/)
        expect(subject.id).to eql(dhash)
      end
    end
  end

  describe "setting type to Text" do
    subject { build(:text_asset) }
    specify { expect(subject.type).to include(AICType.Asset, AICType.Text) }

    describe "#to_solr" do
      before { allow(subject).to receive(:id).and_return('fake-id') }
      specify { expect(subject.to_solr[Solrizer.solr_name("aic_type", :facetable)]).to include("Asset", "Text") }
    end

    describe "minting uids" do
      let(:hash)  { Digest::MD5.hexdigest(subject.uid) }
      let(:dhash) { [hash[0, 8], hash[8, 4], hash[12, 4], hash[16, 4], hash[20..-1]].join('-') }

      before { subject.save }

      it "uses a checksum as a path" do
        expect(subject.id).to match(/^\h{8}-\h{4}-\h{4}-\h{4}-\h{12}/)
        expect(subject.id).to eql(dhash)
      end
    end
  end

  describe "metadata" do
    context "defined in the presenter" do
      AssetPresenter.terms.each do |term|
        it { is_expected.to respond_to(term) }
      end
    end

    context "defined by uris" do
      it { is_expected.to respond_to(:keyword_uris=) }
      it { is_expected.to respond_to(:keyword_uris) }
      it { is_expected.to respond_to(:digitization_source_uri=) }
      it { is_expected.to respond_to(:digitization_source_uri) }
      it { is_expected.to respond_to(:document_type_uri=) }
      it { is_expected.to respond_to(:first_document_sub_type_uri=) }
      it { is_expected.to respond_to(:second_document_sub_type_uri=) }
      it { is_expected.to respond_to(:compositing_uri=) }
      it { is_expected.to respond_to(:light_type_uri=) }
      it { is_expected.to respond_to(:view_uris=) }
      it { is_expected.to respond_to(:document_type_uri) }
      it { is_expected.to respond_to(:first_document_sub_type_uri) }
      it { is_expected.to respond_to(:second_document_sub_type_uri) }
      it { is_expected.to respond_to(:compositing_uri) }
      it { is_expected.to respond_to(:light_type_uri) }
      it { is_expected.to respond_to(:view_uris) }
      it { is_expected.to respond_to(:attachment_of_uris) }
      it { is_expected.to respond_to(:attachment_of_uris=) }
    end
  end

  describe "cardinality" do
    [:capture_device, :dept_created, :digitization_source, :compositing, :light_type, :transcript].each do |term|
      it "limits #{term} to a single value" do
        expect(described_class.properties[term.to_s].multiple?).to be false
      end
    end
  end

  describe "#uid" do
    context "when changed" do
      subject do
        example_file.uid = "1234"
        example_file.save
        example_file.errors
      end
      its(:full_messages) { is_expected.to include("Uid must match checksum") }
    end

    context "when overriding" do
      let(:custom_uid) { build(:asset, uid: "SI-101010") }
      let(:hash)       { UidMinter.new("SI").hash("SI-101010") }
      before { custom_uid.save }
      subject { custom_uid }
      its(:id) { is_expected.to eq(hash) }
    end
  end

  describe "#title" do
    let(:work) { described_class.new }
    subject { work.title.first }
    context "without a pref_label" do
      it { is_expected.to be_nil }
    end
    context "without a pref_label" do
      let(:work) { described_class.create(pref_label: "A Label") }
      it { is_expected.to eq("A Label") }
    end
  end

  describe "FileSet types" do
    let(:asset)        { build(:asset) }
    let(:original)     { build(:original_file_set) }
    let(:intermediate) { build(:intermediate_file_set) }
    let(:preservation) { build(:preservation_file_set) }
    let(:legacy)       { build(:legacy_file_set) }
    let(:other)        { build(:file_set) }

    subject { asset }

    before { asset.members = [original, intermediate, preservation, legacy, other] }

    context "with an original file" do
      its(:original_file_set) { is_expected.to contain_exactly(original) }
    end

    context "with an intermediate file" do
      its(:intermediate_file_set) { is_expected.to contain_exactly(intermediate) }
    end

    context "with a preservation master" do
      its(:preservation_file_set) { is_expected.to contain_exactly(preservation) }
    end

    context "with a legacy file" do
      its(:legacy_file_set) { is_expected.to contain_exactly(legacy) }
    end
  end
end
