require 'rails_helper'

describe GenericFile do
  subject { described_class.new }

  describe "#comments_attributes" do
    let(:commented_resource) do
      build(:asset, comments_attributes: [{ content: "foo comment", category: ["bar category"] }])
    end
    subject { commented_resource.comments.first }
    it { is_expected.to be_kind_of Comment }
    specify "has content and a category" do
      expect(subject.category).to eql ["bar category"]
      expect(subject.content).to eql "foo comment"
    end

    context "without a category" do
      let(:commented_resource) { build(:asset, comments_attributes: [{ content: "foo comment" }]) }
      subject { commented_resource.save }
      it { is_expected.to be true }
    end

    context "without content" do
      let(:commented_resource) { build(:asset, comments_attributes: [{ content: nil }]) }
      subject { commented_resource.save }
      it { is_expected.to be false }
    end

    context "with existing comments" do
      let(:resource) { create(:asset) }
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
        subject { resource.comments.map(&:content) }
        it { is_expected.to include("Updated first comment", "Second comment") }
        it { is_expected.not_to include("First comment") }
      end
    end
  end
end
