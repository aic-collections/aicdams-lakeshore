# frozen_string_literal: true
require 'rails_helper'

describe CurationConcerns::GenericWorksController do
  routes { Rails.application.routes }
  include_context "authenticated saml user"

  describe "#index" do
    before { get :index }
    subject { response }
    it { is_expected.to redirect_to("http://test.host/catalog?f%5Baic_type_sim%5D%5B%5D=Asset") }
  end

  describe "::show_presenter" do
    subject { described_class.show_presenter }
    it { is_expected.to eq(AssetPresenter) }
  end

  describe "#search_builder_class" do
    subject { described_class.new }
    its(:search_builder_class) { is_expected.to eq(AssetSearchBuilder) }
  end

  describe "#update" do
    let(:work)    { create(:still_image_asset, user: user) }
    let(:keyword) { create(:list_item) }
    it "adds a keyword to the work" do
      patch :update, id: work, generic_work: { keyword_uris: [keyword.uri] }
      expect(work.reload.keyword).to contain_exactly(keyword)
    end
  end

  describe "#show" do
    let(:user2)             { create(:user2) }
    let!(:department_asset) { create(:department_asset, user: user2) }
    it "is unauthorized for non-department users" do
      get :show, id: department_asset
      expect(response).to be_unauthorized
    end
  end
  describe "#destroy" do
    context "with relationships" do
      let(:asset2) { create(:asset, user: user, title: ["Title"], pref_label: "Good Title") }
      before { asset2.save! }
      before { allow_any_instance_of(InboundRelationships).to receive(:present?).and_return(true) }

      it "will not delete the resource" do
        number_of_works = GenericWork.all.count

        post "destroy", method: "delete", id: asset2

        expect(number_of_works).to eq(GenericWork.all.count)
      end

      it "will report to user that assets weren't deleted" do
        post "destroy", method: "delete", id: asset2

        expect(flash[:error]).to eq("These assets were not deleted because they have resources linking to them: #{[asset2.title].join}.")
      end
    end

    context "without relationships" do
      let(:asset1) { create(:asset, user: user, title: ["Title"], pref_label: "Good Title") }
      before { asset1.save! }
      it "deletes the resource" do
        number_of_works = GenericWork.all.count

        post "destroy", method: "delete", id: asset1

        expect(GenericWork.all.count).to eq(number_of_works - 1)
      end

      it "will report to user that assets were deleted" do
        post "destroy", method: "delete", id: asset1

        expect(flash[:notice]).to eq("Asset was successfully deleted.")
      end
    end
  end
end
