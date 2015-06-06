require 'rails_helper'

describe TagCatsController do

  let(:user) { FactoryGirl.find_or_create(:jill) }
  before do
    allow(controller).to receive(:has_access?).and_return(true)
    sign_in user
    allow_any_instance_of(User).to receive(:groups).and_return([])
  end

  let(:tag_cat) do
    TagCat.create.tap do |t|
      t.pref_label = "tag category"
      t.apply_depositor_metadata(user)
      t.save
    end
  end

  describe "#new" do
    before { get :new }
    subject { response }
    it { is_expected.to be_successful }
  end

  describe "#create" do
    let(:permissions) { [{"type" => "group", "name" => "public", "access" => "read"}] }
    context "without errors" do
      before { post :create, tag_cat: { pref_label: "new category", permissions_attributes: permissions } }
      specify { expect(response).to be_redirect }
      describe "the category" do
        subject { TagCat.all.first }
        specify { expect(subject.depositor).to eql user.email }
        specify { expect(subject.pref_label).to eql "new category" } 
        specify { expect(subject.read_groups).to include("public") }
      end
    end
    context "with errors" do
      before  { post :create, tag_cat: { permissions_attributes: permissions } }
      specify { expect(response).to be_redirect }
      specify { expect(flash[:error]).to eql "Pref label can't be blank" }
    end
  end

  describe "#edit" do
    before { get :edit, id: tag_cat }
    subject { response }
    it { is_expected.to be_successful }
  end

  describe "#update" do
    let(:permissions) { [{"type" => "group", "name" => "conservation", "access" => "edit"}] }
    before do
      patch :update, id: tag_cat.id, tag_cat: { pref_label: "New label", permissions_attributes: permissions }
      tag_cat.reload
    end
    specify do
      expect(response).to be_redirect
      expect(tag_cat.pref_label).to eql "New label"
      expect(tag_cat.edit_groups).to include("conservation")
    end
  end

  context "when sending an empty permissions form" do
    before { patch :update, id: tag_cat.id, update_permission: "" }
    it "redirects back to the edit page" do
      expect(response).to be_redirect
    end
  end

  describe "#destroy" do
    # TBD
  end

end
