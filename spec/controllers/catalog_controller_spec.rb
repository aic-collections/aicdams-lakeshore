# frozen_string_literal: true
require 'rails_helper'

describe CatalogController do
  include_context "authenticated saml user"

  describe "#search_builder_class" do
    subject { described_class.new }
    its(:search_builder_class) { is_expected.to eq(CatalogSearchBuilder) }
  end

  context "when Lists are present" do
    let!(:list) { create(:list, edit_users: ["user1"]) }
    it "excludes List resources from search results" do
      xhr :get, :index, q: list.pref_label
      expect(response).to be_success
      expect(response).to render_template('catalog/index')
      expect(assigns(:document_list).count).to eql(0)
    end
  end
end
