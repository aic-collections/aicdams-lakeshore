require 'rails_helper'

describe 'batch/edit.html.erb' do
  let(:batch) { Batch.create }
  let(:generic_file) do
    GenericFile.new(title: ['some title']).tap do |f|
      f.apply_depositor_metadata("bob")
      f.comments_attributes = [{ content: "foo comment", category: ["bar category"] }]
    end
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
    within("div#generic_file_document_type_ids") do
      expect(page).to have_content('required="required')
    end
    expect(page).not_to have_selector "input#generic_file_resource_type"
  end
end
