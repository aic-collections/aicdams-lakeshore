# frozen_string_literal: true
require 'rails_helper'

describe CitiResourceActor do
  let(:user)         { create(:user1) }
  let(:non_asset)    { build(:non_asset) }
  let(:actor)        { CurationConcerns::Actors::ActorStack.new(non_asset, user, [described_class]) }
  let(:mock_service) { double(InboundAssetManagementService) }

  before do
    Rails.application.routes.draw do
      namespace :curation_concerns, path: :concern do
        resources :non_assets
        mount Sufia::Engine => '/'
      end
    end

    allow(InboundAssetManagementService).to receive(:new).with(non_asset, user).and_return(mock_service)
  end

  after do
    Rails.application.reload_routes!
  end

  describe "#update" do
    context "with representations" do
      specify do
        expect(mock_service).to receive(:update).with(:preferred_representation, "asset")
        expect(mock_service).to receive(:update).with(:representations, ["asset"])
        expect(mock_service).to receive(:update).with(:documents, nil)
        actor.update(representation_ids: ["asset"])
      end
    end

    context "with documents" do
      specify do
        expect(mock_service).to receive(:update).with(:preferred_representation, nil)
        expect(mock_service).to receive(:update).with(:representations, [])
        expect(mock_service).to receive(:update).with(:documents, ["asset"])
        actor.update(document_ids: ["asset"])
      end
    end
  end
end
