require 'rails_helper'

describe ListsController do
  let(:user) { FactoryGirl.find_or_create(:jill) }
  before { sign_in user }

  describe "#index" do
    before { get :index }
    it "returns a listing of all the lists" do
      expect(response).to be_success
    end
  end

  describe "#show" do
    let(:list) {  List.where(pref_label: "Status").first }
    before { get :show, id: list }
    it "displays all the items in the list" do
      expect(response).to be_success
    end
  end

end
