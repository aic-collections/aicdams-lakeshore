require 'rails_helper'

describe GenericFilesController do
  routes { Sufia::Engine.routes }
  include_context "authenticated saml user"

  let(:generic_file) { create(:asset, user: user) }
  let(:source)       { create(:list_item, pref_label: "source") }
  let(:view)         { create(:list_item, pref_label: "view") }

  describe "#digitization_source" do
    let(:attributes) do
      { digitization_source_id: source.id, view_ids: [view.id] }
    end
    before do
      post :update, id: generic_file, generic_file: attributes
      generic_file.reload
    end
    specify do
      expect(generic_file.digitization_source.pref_label).to eq(source.pref_label)
      expect(generic_file.view.first.pref_label).to eq(view.pref_label)
    end
  end
end
