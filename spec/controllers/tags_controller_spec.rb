require 'rails_helper'

describe TagsController do
  let(:user) { FactoryGirl.find_or_create(:jill) }
  before do
    allow(controller).to receive(:has_access?).and_return(true)
    sign_in user
    allow_any_instance_of(User).to receive(:groups).and_return([])
  end

  let(:aictag)    { Tag.create(content: "Test tag") }

  describe "#update" do
    before { post :update, id: aictag, tag: { content: "foo tag", category: ["bar category"] } }
    it "changes the metadata of the tag" do
      expect(response).to be_redirect
      expect(aictag.reload.content).to eql "foo tag"
      expect(aictag).to be_kind_of(Tag)
      expect(aictag.type).to include(::AICType.Tag)
    end
  end

  describe "#edit" do
    before { get :edit, id: aictag }
    subject { response }
    it { is_expected.to be_successful }
  end

end
