require 'rails_helper'

describe "tags/new.html.erb" do

  let(:tag) { Tag.new }
  let(:form) { TagEditForm.new(tag) }

  before do
    allow(controller).to receive(:current_user).and_return(stub_model(User))
    assign(:tag, tag)
    assign(:form, form)
    render
  end

  subject { rendered }
  it { is_expected.to include "New Tag" }

end
