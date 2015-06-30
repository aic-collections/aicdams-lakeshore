require 'rails_helper'

describe TagsController do
  let(:user) { FactoryGirl.find_or_create(:jill) }
  before do
    allow(controller).to receive(:has_access?).and_return(true)
    sign_in user
    allow_any_instance_of(User).to receive(:groups).and_return([])
  end

  let(:tagcat1) do
    TagCat.create.tap do |t|
      t.pref_label = "tagcat1"
      t.apply_depositor_metadata(user)
      t.save
    end
  end

  let(:tagcat2) do
    TagCat.create.tap do |t|
      t.pref_label = "tagcat2"
      t.apply_depositor_metadata(user)
      t.save
    end
  end

  let(:aictag) { Tag.create(content: "Test tag") }

  describe "#update" do
    context "with good parameters" do
      let(:new_content) { "new tag content" }
      before { post :update, id: aictag, tag: {content: new_content } }
      it "updates the tag's content" do
        expect(response).to be_redirect
        expect(aictag.reload.content).to eql new_content
      end
    end
    context "with bad parameters" do
      before { post :update, id: aictag, tag: {content: "" } }
      it "updates the tag's content" do
        expect(response).to be_redirect
        expect(flash[:error]).to eql "The update was unsuccessful"
      end
    end
    context "when adding categories" do
      let(:attributes) { { tagcat_ids: [tagcat1.id, tagcat2.id] } }
      before { post :update, id: aictag, tag: attributes }
      it "adds new categories to a tag" do
        expect(response).to be_redirect
        aictag.reload
        expect(aictag.tagcats.count).to eql 2
        expect(aictag.tagcats).to include(tagcat1, tagcat2)
      end
      context "then removing them" do
        let(:attributes) { { tagcat_ids: [tagcat1.id] } }
        before { post :update, id: aictag, tag: attributes }
        it "removes the given category from the tag" do
          expect(response).to be_redirect
          aictag.reload
          expect(aictag.tagcats.count).to eql 1
          expect(aictag.tagcats).to include(tagcat1)
        end
      end
      context "with an identical params hash" do
        before { post :update, id: aictag, tag: attributes }
        it "retains the same number of categories" do
          expect(response).to be_redirect
          aictag.reload
          expect(aictag.tagcats.count).to eql 2
          expect(aictag.tagcats).to include(tagcat1, tagcat2)
        end
      end
    end
  end

  describe "#new" do
    before { get :new }
    subject { response }
    it { is_expected.to be_successful }    
  end

  describe "#edit" do
    before { get :edit, id: aictag }
    subject { response }
    it { is_expected.to be_successful }
  end

  describe "#create" do
    context "with good parameters" do
      before { post :create, tag: { content: "new tag content", tagcat_ids: [tagcat1.id, tagcat2.id] } }
      specify "a new tag with tag categories" do
        expect(response).to be_redirect
        expect(flash[:notice]).to eql "A new tag was created"
      end
    end
    context "with no content" do
      before { post :create, tag: { content: "" } }
      specify "no tag is created" do
        expect(response).to be_redirect
        expect(flash[:error]).to eql "Content can't be blank"
      end
    end
  end

end
