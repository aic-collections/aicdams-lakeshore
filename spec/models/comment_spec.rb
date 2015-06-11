require 'rails_helper'

describe Comment do

  let(:content) { "comment content" }
  let(:comment) { Comment.create(content: content) }

  describe "#content" do
    subject { comment.content }
    it { is_expected.to eql content }
  end

  describe "#type" do
    subject { comment.type }
    it { is_expected.to include(AICType.Comment) }
  end

  describe "#category" do
    let(:category) { "comment category" }
    before { comment.category = [category] }
    subject { comment.category }
    it { is_expected.to include category }
  end

end
