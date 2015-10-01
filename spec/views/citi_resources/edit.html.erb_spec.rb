require 'rails_helper'

describe "citi_resources/edit.html.erb" do

  let(:work) { Work.create(pref_label: "Sample Work") }
  let(:form) { WorkEditForm.new(work) }

  before do
    allow(controller).to receive(:current_user).and_return(stub_model(User))
    assign(:work, work)
    assign(:form, form)
    render
  end

  subject { rendered }

  it "has inputs for all id-based nested assets" do
    expect(subject).to include("Edit Resource")
    expect(subject).to include('name="work[asset_ids][]" value="" id="work_asset_ids"')
    expect(subject).to include('name="work[document_ids][]" value="" id="work_document_ids"')
    expect(subject).to include('name="work[representation_ids][]" value="" id="work_representation_ids"')
    expect(subject).to include('name="work[preferred_representation_ids][]" value="" id="work_preferred_representation_ids"')
  end

  it "has appropriate labels and help icons" do
    pending "need to figure out how to override this"
    expect(subject).to include("Documents")
    expect(subject).to include("Representations")
    expect(subject).to include("Preferred representations")
    expect(subject).to include("Assets") 
  end

end
