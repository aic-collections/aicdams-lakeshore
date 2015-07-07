require 'rails_helper'

describe "works/new.html.erb" do

  let(:work) { Work.create(artist_display: ["Picasso"]) }
  let(:form) { WorkEditForm.new(work) }

  before do
    allow(controller).to receive(:current_user).and_return(stub_model(User))
    assign(:work, work)
    assign(:form, form)
    render
  end

  subject { rendered }

  specify do
    expect(subject).to include "New Work"
    expect(subject).to include("value=\"Picasso\"")
  end

end
