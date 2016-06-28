# frozen_string_literal: true
require 'rails_helper'

describe CurationConcerns::GenericWorksController do
  routes { Rails.application.routes }
  include_context "authenticated saml user"
  it_behaves_like "#index redirects to catalog facet search"

  describe "::show_presenter" do
    subject { described_class.show_presenter }
    it { is_expected.to eq(AssetPresenter) }
  end

  describe "#update" do
    let(:work)    { create(:still_image_asset, user: user) }
    let(:keyword) { create(:list_item) }
    it "adds a keyword to the work" do
      patch :update, id: work, generic_work: { keyword_uris: [keyword.uri] }
      expect(work.reload.keyword).to contain_exactly(keyword)
    end
  end
end
