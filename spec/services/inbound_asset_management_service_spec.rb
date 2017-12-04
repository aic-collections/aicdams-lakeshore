# frozen_string_literal: true
require 'rails_helper'

describe InboundAssetManagementService do
  let(:user)      { nil }
  let(:service)   { described_class.new(non_asset, user) }
  let(:asset)     { create(:asset) }
  let(:non_asset) { create(:non_asset) }

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

  subject { asset }

  describe "setting documents" do
    context "with an id" do
      before do
        service.update(:documents, [asset.id])
        asset.reload
      end

      its(:document_of) { is_expected.to contain_exactly(non_asset) }
    end

    context "with a uri" do
      before do
        service.update(:documents, [asset.uri.to_s])
        asset.reload
      end

      its(:document_of) { is_expected.to contain_exactly(non_asset) }
    end
  end

  describe "setting representations" do
    context "with an id" do
      before do
        service.update(:representations, [asset.id])
        asset.reload
      end

      its(:representation_of) { is_expected.to contain_exactly(non_asset) }
    end

    context "with a uri" do
      before do
        service.update(:representations, [asset.uri.to_s])
        asset.reload
      end

      its(:representation_of) { is_expected.to contain_exactly(non_asset) }
    end
  end

  describe "setting a preferred representation" do
    context "with an id" do
      before do
        service.update(:preferred_representation, asset.id)
        asset.reload
      end

      its(:preferred_representation_of) { is_expected.to contain_exactly(non_asset) }
    end

    context "with a uri" do
      before do
        service.update(:preferred_representation, asset.uri.to_s)
        asset.reload
      end

      its(:preferred_representation_of) { is_expected.to contain_exactly(non_asset) }
    end
  end

  describe "setting attachments" do
    let(:parent)  { create(:asset) }
    let(:service) { described_class.new(parent, user) }

    context "with an id" do
      before do
        service.update(:attachments, [asset.id])
        asset.reload
      end

      its(:attachment_of) { is_expected.to contain_exactly(parent) }
    end

    context "with a uri" do
      before do
        service.update(:attachments, [asset.uri.to_s])
        asset.reload
      end

      its(:attachment_of) { is_expected.to contain_exactly(parent) }
    end
  end

  context "when removing a relationship" do
    let!(:asset)     { create(:asset, document_of_uris: [non_asset.uri]) }
    let!(:non_asset) { create(:non_asset) }

    it "removes the relationship from the asset" do
      expect(asset.document_of).to contain_exactly(non_asset)
      service.update(:documents, [])
      asset.reload
      expect(asset.document_of).to be_empty
    end
  end

  context "when replacing a relationship" do
    let!(:old_asset) { create(:asset, document_of_uris: [non_asset.uri]) }
    let!(:asset)     { create(:asset) }
    let!(:non_asset) { create(:non_asset) }

    it "removes the relationship from one resource and adds it to the other" do
      expect(old_asset.document_of).to contain_exactly(non_asset)
      service.update(:documents, [asset.id])
      asset.reload
      old_asset.reload
      expect(old_asset.document_of).to be_empty
      expect(asset.document_of).to contain_exactly(non_asset)
    end
  end

  context "when an asset is a representation of multiple non-assets" do
    let!(:asset)     { create(:asset, representation_of_uris: [other.uri, non_asset.uri]) }
    let!(:other)     { create(:non_asset, pref_label: "Resource to keep") }
    let!(:non_asset) { create(:non_asset, pref_label: "Resource to remove") }

    it "preserves the relationships" do
      expect(asset.representation_of).to contain_exactly(other, non_asset)
      service.update(:representations, [])
      asset.reload
      expect(asset.representation_of).to contain_exactly(other)
    end
  end

  context "when an asset is a preferred representation of multiple non-assets" do
    let!(:old_asset) { create(:asset, preferred_representation_of_uris: [other.uri, non_asset.uri]) }
    let!(:asset)     { create(:asset) }
    let!(:other)     { create(:non_asset, pref_label: "Resource to keep") }
    let!(:non_asset) { create(:non_asset, pref_label: "Resource to remove") }

    it "preserves the relationships" do
      expect(old_asset.preferred_representation_of).to contain_exactly(other, non_asset)
      service.update(:preferred_representation, asset.uri)
      old_asset.reload
      asset.reload
      expect(old_asset.preferred_representation_of).to contain_exactly(other)
      expect(asset.preferred_representation_of).to contain_exactly(non_asset)
    end
  end
end
