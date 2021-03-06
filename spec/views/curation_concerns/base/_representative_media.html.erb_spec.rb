# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'curation_concerns/base/_representative_media' do
  let(:user) { create(:user1) }
  let(:pres) { AssetPresenter.new(solr_doc, nil) }
  let(:file_set) { FileSet.create! { |fs| fs.apply_depositor_metadata(user) } }
  let(:file_presenter) { double('file presenter', id: file_set.id, image?: true) }

  before do
    allow(pres).to receive_messages(representative_presenter: file_presenter)
    Hydra::Works::AddFileToFileSet.call(file_set,
                                        File.open(fixture_path + '/sun.png'),
                                        :original_file)
    render 'curation_concerns/base/representative_media', presenter: pres
  end

  context "with a still image asset" do
    let(:solr_doc) { double(representative_id: file_set.id, hydra_model: GenericWork, type: [AICType.StillImage]) }
    it 'has a universal viewer' do
      expect(rendered).to have_selector 'div.uv'
    end
  end

  context "with a text asset" do
    let(:solr_doc) { double(representative_id: file_set.id, hydra_model: GenericWork, type: [AICType.Text]) }
    it 'has a universal viewer' do
      expect(rendered).to have_selector 'div.uv'
    end
  end
end
