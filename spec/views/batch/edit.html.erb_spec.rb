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
    render
  end

  it "does not show Sufia's keyword field" do
    expect(render).not_to have_selector "input#generic_file_resource_type"
  end
end
