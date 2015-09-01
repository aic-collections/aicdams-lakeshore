require 'rails_helper'

describe GenericFile do

  subject { GenericFile.new }

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
  end

  describe "metadata" do
    context "defined in the presenter" do
      AssetPresenter.terms.each do |term|
        it { is_expected.to respond_to(term) }
      end
    end
  end

  describe "#comments_attributes" do

    let(:commented_resource) do
      GenericFile.create.tap do |file|
        file.title = ["Commented thing"]
        file.apply_depositor_metadata "user"
        file.comments_attributes = [{content: "foo comment", category: ["bar category"]}]
      end
    end

    subject { commented_resource.comments.first }
    it { is_expected.to be_kind_of Comment }
    specify "has content and a category" do
      expect(subject.category).to eql ["bar category"]
      expect(subject.content).to eql "foo comment"
    end

    context "without a category" do
      let(:commented_resource) do
        GenericFile.create.tap do |file|
          file.title = ["Commented thing without a category"]
          file.apply_depositor_metadata "user"
          file.comments_attributes = [{content: "foo comment"}]
        end
      end
      subject { commented_resource.save }
      it { is_expected.to be true }
    end

    context "without content" do
      let(:commented_resource) do
        GenericFile.create.tap do |file|
          file.title = ["Commented thing without a category"]
          file.apply_depositor_metadata "user"
          file.comments_attributes = [{content: nil}]
        end
      end
      subject { commented_resource.save }
      it { is_expected.to be false }
    end

    context "with existing comments" do
      let(:resource) do
        GenericFile.create.tap do |file|
          file.apply_depositor_metadata "user"
        end
      end
      let(:c1) { Comment.create(content: "First comment") }
      let(:c2) { Comment.create(content: "Second comment") }
      before do
        resource.comments = [c1, c2]
        resource.save
      end

      describe "#comments" do
        subject { resource.comments }
        it { is_expected.to include(c1, c2) }
      end

      describe "updating a comment with a given id" do
        before do
          resource.comments_attributes = [id: c1.id, content: "Updated first comment"]
          resource.save
        end
        subject { resource.comments.map {|c| c.content} }
        it {is_expected.to include("Updated first comment", "Second comment")}
        it {is_expected.not_to include("First comment")}
      end

    end

  end

  describe "#aictag_ids", broken: true do
    let(:pref_label) { "bar category" }
    let(:content) { "the tag's content" }
    let(:category) do
      TagCat.create.tap do |t|
        t.pref_label = pref_label
        t.apply_depositor_metadata "user"
      end
    end
    let(:tag) do
      Tag.create.tap do |t|
        t.content = content
      end
    end
    let(:tagged_resource) do
      GenericFile.create.tap do |file|
        file.title = ["Tagged thing"]
        file.apply_depositor_metadata "user"
      end
    end

    before do
      tag.tagcats = [category]
      tag.save
      tagged_resource.aictag_ids = [tag.id]
      tagged_resource.save
    end

    subject { tagged_resource.aictags.first }
    it { is_expected.to be_kind_of Tag }
    specify "has content and categories" do
      expect(subject.tagcats.first.pref_label).to eql pref_label
      expect(subject.content).to eql content
    end
  end

  describe "cardinality" do
    let(:single_terms) { [:asset_capture_device, :digitization_source, :document_type] }
    specify "limits terms to single values" do
      single_terms.each do |term|
        subject.send(term.to_s+"=","foo")
        expect(subject.send(term.to_s)).to eql "foo"
      end
    end
  end

  describe "loading from solr" do
    let(:example_file) do
      GenericFile.create.tap do |file|
        file.apply_depositor_metadata "user"
        file.save!
      end
    end
    subject { ActiveFedora::Base.load_instance_from_solr(example_file.id) }
    it { is_expected.to be_kind_of GenericFile }
  end

  describe "#destroy" do
    let(:resource) do
      GenericFile.create.tap do |file|
        file.apply_depositor_metadata "user"
        file.save
      end
    end
    it "deletes the resource" do
      expect(resource.destroy).to be_kind_of(GenericFile)
    end

  end

end
