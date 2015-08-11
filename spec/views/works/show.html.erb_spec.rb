require 'rails_helper'

describe "works/show.html.erb" do

  let(:asset) do
    stub_model(GenericFile, id: 'abc',
      title: ["Asset title"]
    )
  end

  let(:work) do
    stub_model(Work, id: '123',
      title: ["Sample Work"],
      artist_display: ["Picasso"]
    )
  end
  let(:presenter) { WorkPresenter.new(work) }

  before do
    allow(controller).to receive(:current_user).and_return(stub_model(User))
    allow(work).to receive(:assets).and_return([asset])
    assign(:work, work)
    assign(:presenter, presenter)
    render
  end

  subject { rendered }

  specify do
    expect(subject).to include('<h2>Assets</h2>')
    expect(subject).to include('src="/downloads/abc?file=thumbnail"')
  end

end
