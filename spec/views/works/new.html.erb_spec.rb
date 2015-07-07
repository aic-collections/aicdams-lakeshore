require 'rails_helper'

describe "works/new.html.erb" do

  let(:work) { Work.new }
  let(:form) { WorkEditForm.new(work) }

  before do
    allow(controller).to receive(:current_user).and_return(stub_model(User))
    assign(:work, work)
    assign(:form, form)
    render
  end

  subject { Capybara::Node::Simple.new(rendered) }

  specify do
    expect(subject).to have_content "New Work"
    expect(subject).to have_selector("input#work_asset_ids", count: 1)
    expect(subject).to have_selector("input#work_after", count: 1)
    expect(subject).to have_selector("input#work_artist_display", count: 1)
    expect(subject).to have_selector("input#work_artist_uid", count: 1)
    expect(subject).to have_selector("input#work_before", count: 1)
    expect(subject).to have_selector("input#work_coll_cat_uid", count: 1)
    expect(subject).to have_selector("input#work_credit_line", count: 1)
    expect(subject).to have_selector("input#work_dept_uid", count: 1)
    expect(subject).to have_selector("input#work_dimensions_display", count: 1)
    expect(subject).to have_selector("input#work_exhibition_history", count: 1)
    expect(subject).to have_selector("input#work_gallery_location", count: 1)
    expect(subject).to have_selector("input#work_inscriptions", count: 1)
    expect(subject).to have_selector("input#work_main_ref_number", count: 1)
    expect(subject).to have_selector("input#work_medium_display", count: 1)
    expect(subject).to have_selector("input#work_object_type", count: 1)
    expect(subject).to have_selector("input#work_place_of_origin", count: 1)
    expect(subject).to have_selector("input#work_provenance_text", count: 1)
    expect(subject).to have_selector("input#work_publication_history", count: 1)
    expect(subject).to have_selector("input#work_publ_tag", count: 1)
    expect(subject).to have_selector("input#work_publ_ver_level", count: 1)
  end

end
