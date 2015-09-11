require 'rails_helper'

describe "works/edit.html.erb" do

  let(:work) { Work.create(pref_label: "Sample Work") }
  let(:form) { WorkEditForm.new(work) }

  before do
    allow(controller).to receive(:current_user).and_return(stub_model(User))
    assign(:work, work)
    assign(:form, form)
    render
  end

  subject { rendered }

  specify do
    expect(subject).to include("Edit Work")
    expect(subject).to include("Documents")
    expect(subject).to include("Representations")
    expect(subject).to include("Preferred representations")
  end

end
