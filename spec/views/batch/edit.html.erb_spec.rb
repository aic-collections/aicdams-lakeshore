require 'rails_helper'

describe 'batch/edit.html.erb' do
  let(:batch) { Batch.create }
  let(:generic_file) do
    build(:asset,
          comments_attributes: [{ content: "foo comment", category: ["bar category"] }]
         )
  end
  let(:form) { AssetBatchEditForm.new(generic_file) }

  before do
    allow(controller).to receive(:current_user).and_return(stub_model(User))
    assign :batch, batch
    assign :form, form
  end

  let(:page) do
    render
    Capybara::Node::Simple.new(rendered)
  end

  it "draws the form" do
    within("div#generic_file_document_type_ids") { expect(page).to have_content('required="required') }
    expect(page).not_to have_selector("input#generic_file_resource_type")
    expect(page).not_to have_selector("select#generic_file_status_id")
    within("div.generic_file_representation_for") { expect(page).to have_selector("input.hidden") }
    within("div.generic_file_document_for") { expect(page).to have_selector("input.hidden") }
  end
end
