require 'rails_helper'

describe "tag_cats/edit.html.erb" do

  let(:tag_cat) do
    TagCat.create.tap do |t|
      t.pref_label = "pref_label"
      t.apply_depositor_metadata "user"
      t.save
    end
  end
  let(:form) { TagCatEditForm.new(tag_cat) }

  before do
    allow(controller).to receive(:current_user).and_return(stub_model(User))
    assign(:tag_cat, tag_cat)
    assign(:form, form)
    render
  end

  subject { rendered }
  it { is_expected.to include "Edit tag category" }
  it { is_expected.to include 'Depositor (<span id="file_owner" data-depositor="user">user</span>)' }
  it { is_expected.to include '<div id="permissions_display" class="tab-pane">' }
  it { is_expected.to include '<div id="descriptions_display" class="tab-pane active">' }

end
