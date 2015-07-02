require 'rails_helper'

describe "tags/edit.html.erb" do

  let(:tag_cat1) do
    TagCat.create.tap do |t|
      t.pref_label = "pref_label"
      t.apply_depositor_metadata "user"
      t.save
    end
  end
  let(:tag_cat2) do
    TagCat.create.tap do |t|
      t.pref_label = "pref_label"
      t.apply_depositor_metadata "user"
      t.save
    end
  end
  let(:tag) do 
    Tag.create.tap do |t|
      t.content "tag content"
      t.tagcat_ids = [tag_cat1.id, tag_cat2.id]
      t.save
    end
  end
  let(:form) { TagEditForm.new(tag) }

  before do
    allow(controller).to receive(:current_user).and_return(stub_model(User))
    assign(:tag, tag)
    assign(:form, form)
    render
  end

  subject { rendered }
  it { is_expected.to include "Edit Tag" }
  it { is_expected.to include(tag_cat1.id, tag_cat2.id) }

end
