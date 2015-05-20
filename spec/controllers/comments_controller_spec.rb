require 'rails_helper'

describe CommentsController do
  let(:user) { FactoryGirl.find_or_create(:jill) }
  before do
    allow(controller).to receive(:has_access?).and_return(true)
    sign_in user
    allow_any_instance_of(User).to receive(:groups).and_return([])
  end

  let(:comment)   { Comment.create(content: "Test comment") }

  describe "#update" do
    before { post :update, id: comment, comment: { content: "foo comment", category: ["bar category"] } }
    it "changes the metadata of the comment" do
      expect(response).to be_redirect
      expect(comment.reload.content).to eql "foo comment"
      expect(comment).to be_kind_of(Comment)
      expect(comment.type).to include(::AICType.Comment)
    end
  end

  describe "#edit" do
    before { get :edit, id: comment }
    subject { response }
    it { is_expected.to be_successful }
  end

end
