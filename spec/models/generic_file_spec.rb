require 'rails_helper'

describe GenericFile do

  subject { GenericFile.new }

  context "without setting a type" do
    before { subject.apply_depositor_metadata("user") }
    it "raises and error" do
      expect( lambda { subject.save }).to raise_error(ArgumentError, "Can't assign a prefix without a type")
    end
  end

  describe "intial RDF types" do
    subject { GenericFile.new.type }
    it { is_expected.to include(AICType.Asset, AICType.Resource) }
  end
  
  describe "asserting StillImage" do
    before  { subject.assert_still_image }
    specify { expect(subject.type).to include(AICType.Asset, AICType.StillImage) }
    context "and re-asserting StillImage" do
      before  { subject.assert_still_image }
      specify { expect(subject).not_to receive(:set_value)}
    end
    context "and asserting Text" do
      specify { expect(subject.assert_text).to be false }
    end
    describe "#to_solr" do
      before do
        allow(subject).to receive(:file_size).and_return(["1234"])
        allow(subject).to receive(:width).and_return(["8"])
        allow(subject).to receive(:height).and_return(["12"])

      end
      it "contains our custom solr fields" do
        expect(subject.to_solr[Solrizer.solr_name("aic_type", :facetable)]).to include("Asset", "Still Image")
        expect(subject.to_solr[CatalogController.file_size_field]).to eq "1234"
        expect(subject.to_solr[Solrizer.solr_name("image_width", :searchable, type: :integer)]).to eq ["8"]
        expect(subject.to_solr[Solrizer.solr_name("image_height", :searchable, type: :integer)]).to eq ["12"]
      end
    end
    describe "minting uids" do
      before do
        subject.apply_depositor_metadata "user"
        subject.save
      end
      it "uses a UID for still images" do
        expect(subject.id).to start_with("SI")
        expect(subject.uri).not_to match(/\/-/)
        expect(subject.uid).to eql(subject.id)
      end
    end
  end
  
  describe "setting type to Text" do
    before  { subject.assert_text }
    specify { expect(subject.type).to include(AICType.Asset, AICType.Text) }
    context "and re-asserting Text" do
      before  { subject.assert_text }
      specify { expect(subject).not_to receive(:set_value)}
    end
    context "and asserting StillImage" do
      specify { expect(subject.assert_still_image).to be false }
    end
    describe "#to_solr" do
      specify { expect(subject.to_solr[Solrizer.solr_name("aic_type", :facetable)]).to include("Asset", "Text") }
    end
    describe "minting uids" do
      before do
        subject.apply_depositor_metadata "user"
        subject.save
      end
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
        pending "Can't enforce singular AT resources" unless term == :asset_capture_device
        subject.send(term.to_s+"=","foo")
        expect(subject.send(term.to_s)).to eql "foo"
      end
    end
  end

  describe "loading from solr" do
    let(:example_file) do
      GenericFile.create.tap do |file|
        file.apply_depositor_metadata "user"
        file.assert_still_image
        file.save
      end
    end
    subject { ActiveFedora::Base.load_instance_from_solr(example_file.id) }
    it { is_expected.to be_kind_of GenericFile }
  end

  describe "#destroy" do
    let(:resource) do
      GenericFile.create.tap do |file|
        file.apply_depositor_metadata "user"
        file.assert_still_image
        file.save
      end
    end
    it "deletes the resource" do
      expect(resource.destroy).to be_kind_of(GenericFile)
    end
  end

end
