require 'rails_helper'

describe GenericFile do
  let(:user)         { create(:user1) }
  let(:example_file) { create(:asset) }

  subject { described_class.new }

  context "without setting a type" do
    subject { build(:asset_without_type) }
    it "raises and error" do
      expect(-> { subject.save }).to raise_error(ArgumentError, "Can't assign a prefix without a type")
    end
  end

  describe "intial RDF types" do
    subject { described_class.new.type }
    it { is_expected.to include(AICType.Asset, AICType.Resource) }
  end

  describe "asserting StillImage" do
    subject { build(:asset) }
    specify { expect(subject.type).to include(AICType.Asset, AICType.StillImage) }
    context "and re-asserting StillImage" do
      before  { subject.assert_still_image }
      specify { expect(subject).not_to receive(:set_value) }
    end
    context "and asserting Text" do
      specify { expect(subject.assert_text).to be false }
    end
    describe "#to_solr" do
      before do
        subject.tag_ids = [Tag.all.first.id]
        allow(subject).to receive(:file_size).and_return(["1234"])
        allow(subject).to receive(:width).and_return(["8"])
        allow(subject).to receive(:height).and_return(["12"])
      end
      it "contains our custom solr fields" do
        expect(subject.to_solr[Solrizer.solr_name("aic_type", :facetable)]).to include("Asset", "Still Image")
        expect(subject.to_solr[CatalogController.file_size_field]).to eq "1234"
        expect(subject.to_solr[Solrizer.solr_name("image_width", :searchable, type: :integer)]).to eq ["8"]
        expect(subject.to_solr[Solrizer.solr_name("image_height", :searchable, type: :integer)]).to eq ["12"]
        expect(subject.to_solr[Solrizer.solr_name("tag", :facetable)]).to contain_exactly(Tag.all.first.pref_label)
        expect(subject.to_solr[Solrizer.solr_name("tag", :stored_searchable)]).to contain_exactly(Tag.all.first.pref_label)
      end
    end
    describe "minting uids" do
      before { subject.save }
      it "uses a UID for still images" do
        expect(subject.id).to start_with("SI")
        expect(subject.uri).not_to match(/\/-/)
        expect(subject.uid).to eql(subject.id)
      end
    end
  end

  describe "setting type to Text" do
    subject { build(:text_asset) }
    specify { expect(subject.type).to include(AICType.Asset, AICType.Text) }
    context "and re-asserting Text" do
      before  { subject.assert_text }
      specify { expect(subject).not_to receive(:set_value) }
    end
    context "and asserting StillImage" do
      specify { expect(subject.assert_still_image).to be false }
    end
    describe "#to_solr" do
      specify { expect(subject.to_solr[Solrizer.solr_name("aic_type", :facetable)]).to include("Asset", "Text") }
    end
    describe "minting uids" do
      before { subject.save }
      it "uses a UID for still images" do
        expect(subject.id).to start_with("TX")
        expect(subject.uri).not_to match(/\/-/)
      end
    end
  end

  describe "metadata" do
    context "defined in the presenter" do
      AssetPresenter.terms.each do |term|
        it { is_expected.to respond_to(term) }
      end
    end
  end

  describe "cardinality" do
    [:asset_capture_device, :digitization_source, :document_type].each do |term|
      it "limits #{term} to a single value" do
        pending "Can't enforce singular AT resources" if term == :document_type
        subject.send(term.to_s + "=", "foo")
        expect(subject.send(term.to_s)).to eql "foo"
      end
    end
  end

  describe "loading from solr" do
    subject { ActiveFedora::Base.load_instance_from_solr(example_file.id) }
    it { is_expected.to be_kind_of described_class }
  end

  describe "#destroy" do
    it "deletes the resource" do
      expect(example_file.destroy).to be_kind_of(described_class)
    end
  end

  describe "#uid" do
    context "when changed" do
      subject do
        example_file.uid = "1234"
        example_file.save
        example_file.errors
      end
      its(:full_messages) { is_expected.to include("Uid must match id") }
    end
  end
end
