require 'rails_helper'

describe "comments/edit.html.erb" do

  let(:comment) { Comment.create(content: "A comment") }
  let(:form) { AnnotationEditForm.new(comment) }

  before do
    allow(controller).to receive(:current_user).and_return(stub_model(User))
    assign(:annotation, comment)
    assign(:form, form)
    render
  end

  subject { rendered }
  it { is_expected.to include "Edit Comment" }

end
