require 'rails_helper'

describe Comment do
  let(:content) { "comment content" }
  let(:comment) { described_class.create(content: content) }

  describe "RDF types" do
    subject { described_class.new.type }
    it { is_expected.to contain_exactly(AICType.Comment, AICType.Annotation, AICType.Resource) }
  end

  describe "#content" do
    subject { comment.content }
    it { is_expected.to eql content }
  end

  describe "#category" do
    let(:category) { "comment category" }
    before { comment.category = [category] }
    subject { comment.category }
    it { is_expected.to include category }
  end

  describe "#destroy" do
    subject do
      comment.save
      comment
    end
    it "deletes the resource" do
      expect(subject.destroy).to be_kind_of(described_class)
    end
  end
end
