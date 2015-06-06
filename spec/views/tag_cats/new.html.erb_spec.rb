require 'rails_helper'

describe "tag_cats/new.html.erb" do

  let(:tag_cat) { TagCat.new }
  let(:form) { TagCatEditForm.new(tag_cat) }

  before do
    allow(controller).to receive(:current_user).and_return(stub_model(User))
    assign(:tag_cat, tag_cat)
    assign(:form, form)
    render
  end

  subject { rendered }
  it { is_expected.to include "New tag category" }

end
