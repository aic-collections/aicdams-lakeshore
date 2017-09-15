# frozen_string_literal: true
require 'rails_helper'

describe CitiResourceActor do
  let(:user)               { create(:user1) }
  let(:asset1)             { create(:asset) }
  let(:asset2)             { create(:asset) }
  let(:intermediate_asset) { create(:asset, :with_intermediate_file_set) }
  let(:actor)              { CurationConcerns::Actors::ActorStack.new(non_asset, user, [described_class]) }

  before do
    Rails.application.routes.draw do
      namespace :curation_concerns, path: :concern do
        resources :non_assets
        mount Sufia::Engine => '/'
      end
    end
  end

  after do
    Rails.application.reload_routes!
  end

  describe "#update" do
    context "without any changes to the preferred representation" do
      let!(:non_asset) { create(:non_asset) }

      it "does not notify CITI" do
        expect(CitiNotificationJob).not_to receive(:perform_later)
        actor.update({})
      end
    end

    context "when the asset's updated preferred representation does not have an intermediate file set" do
      let!(:non_asset) { create(:non_asset, preferred_representation_uri: asset1.uri) }

      it "does not notify CITI" do
        expect(CitiNotificationJob).not_to receive(:perform_later)
        actor.update("preferred_representation_uri" => asset2.uri.to_s)
        expect(non_asset.preferred_representation_uri).to eq(asset2.uri)
      end
    end

    context "when the asset's updated preferred representation has an intermediate file set" do
      let!(:non_asset) { create(:non_asset, preferred_representation_uri: asset1.uri) }

      it "notifies CITI" do
        expect(CitiNotificationJob).to receive(:perform_later)
        actor.update("preferred_representation_uri" => intermediate_asset.uri.to_s)
        expect(non_asset.preferred_representation_uri).to eq(intermediate_asset.uri)
      end
    end

    context "when removing the preferred representation" do
      let!(:non_asset) { create(:non_asset, preferred_representation_uri: asset1.uri) }

      it "notifies CITI" do
        expect(CitiNotificationJob).to receive(:perform_later)
        actor.update("preferred_representation_uri" => "")
        expect(non_asset.preferred_representation_uri).to be_nil
      end
    end

    context "with representations and no preferred representation" do
      let!(:non_asset) { create(:non_asset, representation_uris: [asset1.uri]) }

      it "adds a preferred representation" do
        actor.update(representation_uris: [asset1.uri.to_s], "preferred_representation_uri" => "")
        expect(non_asset.preferred_representation_uri).to eq(asset1.uri)
      end
    end
  end
end
