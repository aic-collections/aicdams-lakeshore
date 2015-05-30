require 'rails_helper'

describe GenericFile do

  subject { GenericFile.new }

  describe "terms" do
    it { is_expected.to respond_to(:batch_uid) }
    it { is_expected.to respond_to(:aiccreated) }
    it { is_expected.to respond_to(:department) }
    it { is_expected.to respond_to(:comments) }
    it { is_expected.to respond_to(:location) }
    it { is_expected.to respond_to(:metadata) }
    it { is_expected.to respond_to(:publishing_context) }
    it { is_expected.to respond_to(:aictags) }
    it { is_expected.to respond_to(:legacy_uid) }
    it { is_expected.to respond_to(:status) }
    it { is_expected.to respond_to(:uid) }
    it { is_expected.to respond_to(:updated) }
    it { is_expected.to respond_to(:contributor) }
    it { is_expected.to respond_to(:coverage) }
    it { is_expected.to respond_to(:date) }
    it { is_expected.to respond_to(:description) }
    it { is_expected.to respond_to(:format) }
    it { is_expected.to respond_to(:identifier) }
    it { is_expected.to respond_to(:language) }
    it { is_expected.to respond_to(:publisher) }
    it { is_expected.to respond_to(:relation) }
    it { is_expected.to respond_to(:rights) }
    it { is_expected.to respond_to(:source) }
    it { is_expected.to respond_to(:subject) }
    it { is_expected.to respond_to(:title) }
    it { is_expected.to respond_to(:resource_type) }
    it { is_expected.to respond_to(:described_by) }
    it { is_expected.to respond_to(:same_as) }
    it { is_expected.to respond_to(:pref_label) }
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

  describe "aictags" do
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
      tagged_resource.aictags = [tag]
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
    let(:single_terms) { [:batch_uid, :aiccreated, :department, :status, :updated, :pref_label] }
    specify "limits terms to single values" do
      single_terms.each do |term|
        subject.send(term.to_s+"=","foo")
        expect(subject.send(term.to_s)).to eql "foo"
      end
    end
  end

  describe "terms writable during creation only" do
    let(:wro_single_terms) { [:batch_uid, :aiccreated, :department] }
    let(:error_message) { "is writable only on create"}
    let(:first_value) { "write-once value" }
    subject do
      GenericFile.create.tap do |file|
        file.batch_uid  = first_value
        file.aiccreated = first_value
        file.department = first_value
        file.legacy_uid = [first_value] 
        file.apply_depositor_metadata "user"
        file.save!
      end
    end
    specify "are not updateable" do
      wro_single_terms.each do |term|
        expect(subject.send(term)).to eql first_value
        subject.send(term.to_s+"=", "a changed value")
        expect(subject.save).to be false
        expect(subject.errors[term]).to eql([error_message])
      end
      expect(subject.legacy_uid).to eql [first_value]
      subject.legacy_uid = ["more","values"]
      expect(subject.save).to be false
      expect(subject.errors[:legacy_uid]).to eql([error_message])  
    end
  end

  describe "required terms" do
    subject do
      GenericFile.create.tap do |file|
        file.apply_depositor_metadata "user"
        file.save!
      end
    end
    it { is_expected.to be_kind_of GenericFile }
    specify "uid matches the id" do
      expect(subject.uid).to eql subject.id
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


end
