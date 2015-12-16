require 'rails_helper'

describe "comments/edit.html.erb" do
  let(:comment) { Comment.create(content: "A comment") }
  let(:form)    { CommentEditForm.new(comment) }

  before do
    allow(controller).to receive(:current_user).and_return(stub_model(User))
    assign(:comment, comment)
    assign(:form, form)
    render
  end

  subject { rendered }
  it { is_expected.to include "<h4>Edit Comment</h4>" }
  it { is_expected.to include 'value="A comment"' }
end
