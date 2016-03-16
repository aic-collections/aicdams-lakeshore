require 'rails_helper'

describe ListsController do
  include_context "authenticated saml user"
  let(:list) { create(:list) }
  subject { response }

  describe "#index" do
    before { get :index }
    it { is_expected.to be_success }
  end

  describe "#show" do
    context "with an admin user" do
      include_context "authenticated admin user"
      before { get :show, id: list }
      it { is_expected.to be_success }
    end
    context "with a user that does not have edit access" do
      before { get :show, id: list }
      it { is_expected.to be_redirect }
    end
  end

  describe "#edit" do
    context "with an admin user" do
      include_context "authenticated admin user"
      before { get :edit, id: list }
      it { is_expected.to be_success }
    end
    context "with a user that does not have edit access" do
      before { get :edit, id: list }
      it { is_expected.to be_redirect }
    end
  end

  describe "#update" do
    subject { list }
    context "with an admin user" do
      include_context "authenticated admin user"
      before do
        patch :update, id: list, list: { permissions_attributes: [{ type: 'person', name: 'joeuser', access: 'edit' }] }
        subject.reload
      end
      its(:edit_users) { is_expected.to contain_exactly('joeuser', 'user2') }
    end
    context "with a user that does not have edit access" do
      it "redirects and does not save" do
        patch :update, id: list
        expect(list).not_to receive(:save)
        expect(response).to be_redirect
      end
    end
  end
end
