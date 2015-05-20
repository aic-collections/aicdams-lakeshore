require 'rails_helper'

describe "tags/edit.html.erb" do

  let(:tag) { Tag.create(content: "A tag") }
  let(:form) { AnnotationEditForm.new(tag) }

  before do
    allow(controller).to receive(:current_user).and_return(stub_model(User))
    assign(:annotation, tag)
    assign(:form, form)
    render
  end

  subject { rendered }
  it { is_expected.to include "Edit Tag" }

end
