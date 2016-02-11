require 'rails_helper'

describe GenericFilesController do
  routes { Sufia::Engine.routes }
  include_context "authenticated saml user"

  let(:generic_file) do
    GenericFile.create do |gf|
      gf.apply_depositor_metadata(user)
      gf.assert_still_image
    end
  end

  describe "#digitization_source" do
    let(:attributes) do
      {
        digitization_source_id: DigitizationSource.all.first.id,
        compositing_id:         Compositing.all.first.id,
        light_type_id:          LightType.all.first.id,
        view_ids:               View.all.map(&:id),
        document_type_ids:      DocumentType.all.map(&:id),
        tag_ids:                Tag.all.map(&:id)
      }
    end
    before do
      post :update, id: generic_file, generic_file: attributes
      generic_file.reload
    end
    specify do
      expect(generic_file.digitization_source.pref_label).to eq(DigitizationSource.all.first.pref_label)
      expect(generic_file.compositing.pref_label).to eq(Compositing.all.first.pref_label)
      expect(generic_file.light_type.pref_label).to eq(LightType.all.first.pref_label)
      expect(generic_file.view.first.pref_label).to eq(View.all.first.pref_label)
      expect(generic_file.document_type.first.pref_label).to eq(DocumentType.all.first.pref_label)
      expect(generic_file.tag.first.pref_label).to eq(Tag.all.first.pref_label)
    end
  end
end
