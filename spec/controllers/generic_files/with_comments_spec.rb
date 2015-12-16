require 'rails_helper'

describe GenericFilesController do
  routes { Sufia::Engine.routes }
  let(:user) { FactoryGirl.find_or_create(:jill) }
  before do
    allow(controller).to receive(:has_access?).and_return(true)
    sign_in user
    allow_any_instance_of(User).to receive(:groups).and_return([])
    allow_any_instance_of(GenericFile).to receive(:characterize)
  end

  let(:generic_file) do
    GenericFile.create do |gf|
      gf.apply_depositor_metadata(user)
      gf.assert_still_image
    end
  end
  let(:comment1) { Comment.create(content: "first comment") }
  let(:comment2) { Comment.create(content: "second comment") }
  let(:comment3) { Comment.create(content: "third comment", category: ["bat", "baz"]) }

  describe "adding new comments" do
    let(:attributes) do
      { comments_attributes: [{ content: "foo comment", category: ["bar category"] }] }
    end

    before { post :update, id: generic_file, generic_file: attributes }
    subject { generic_file.reload }

    it "sets the values using the parameters hash" do
      expect(subject.comments.first.content).to eql "foo comment"
      expect(subject.comments.first.category).to eql ["bar category"]
    end
  end

  describe "adding new comments without categories" do
    let(:attributes) do
      { comments_attributes: { "0" => { "content" => "some comment", "_destroy" => "false" } } }
    end

    before { post :update, id: generic_file, generic_file: attributes }
    subject { generic_file.reload }

    it "sets the values using the parameters hash" do
      expect(subject.comments.first.content).to eql "some comment"
    end
  end

  describe "updating existing comments" do
    let(:attributes) do
      {
        comments_attributes: {
          "0" => { id: comment1.id, content: "updated first comment", category: ["new category"] },
          "1" => { id: comment2.id, content: "second comment" }
        }
      }
    end

    before do
      generic_file.comments = [comment1, comment2]
      generic_file.save
      post :update, id: generic_file, generic_file: attributes
    end
    subject { generic_file.reload }
    it "sets the values using the parameters hash" do
      expect(subject.comments.first.content).to eql "updated first comment"
      expect(subject.comments.first.category).to eql ["new category"]
      expect(subject.comments.second.content).to eql "second comment"
    end

    context "when the form sends empty comments" do
      let(:empty_comments) do
        {
          comments_attributes: {
            "0" => { id: comment1.id, _destroy: "false", content: "new comment" },
            "1" => { _destroy: "false", content: "" }
          }
        }
      end

      before do
        generic_file.comments = [comment1]
        generic_file.save
      end

      it "removes them from the attributes hash" do
        post :update, id: generic_file, generic_file: empty_comments
        expect(response).to be_redirect
      end
    end
  end

  describe "removing existing comments" do
    let(:attributes) do
      {
        comments_attributes: {
          "0" => { id: comment1.id, "_destroy" => true },
          "1" => { id: comment2.id, content: "updated second comment" }
        }
      }
    end

    before do
      generic_file.comments = [comment1, comment2]
      generic_file.save
      post :update, id: generic_file, generic_file: attributes
    end
    subject { generic_file.reload }
    it "removes the comment from the resource" do
      expect(subject.comments.first.content).to eql "updated second comment"
      expect(subject.comments.count).to eql 1
      expect(Comment.all.map(&:content)).to include("first comment", "updated second comment")
    end
  end

  describe "updating comments with categories" do
    let(:attributes) do
      {
        comments_attributes: {
          "0" => { id: comment3.id, category: ["bat", "buz"] }
        }
      }
    end

    before do
      generic_file.comments = [comment3]
      generic_file.save
      post :update, id: generic_file, generic_file: attributes
    end

    subject { generic_file.reload }
    it "updates the categories of the comment" do
      expect(subject.comments.first.category).to include("bat", "buz")
      expect(subject.comments.first.category).not_to include("baz")
    end
  end

  describe "removing categories from comments" do
    let(:attributes) do
      {
        comments_attributes: {
          "0" => { id: comment3.id, category: ["buz"] }
        }
      }
    end

    before do
      generic_file.comments = [comment3]
      generic_file.save
      post :update, id: generic_file, generic_file: attributes
    end

    subject { generic_file.reload }
    it "updates the categories of the comment" do
      expect(subject.comments.first.category).to eql(["buz"])
    end
  end
end
