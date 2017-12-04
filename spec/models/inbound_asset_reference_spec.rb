# frozen_string_literal: true
require 'rails_helper'

describe InboundAssetReference do
  let(:citi_resource) { create(:non_asset) }

  subject { described_class.new(citi_resource) }

  context "with representations" do
    let!(:asset1) { create(:asset, representation_of_uris: [citi_resource.uri]) }
    let!(:asset2) { create(:asset, representation_of_uris: [citi_resource.uri]) }

    it "returns solr documents and ids" do
      expect(subject.representations).to include(kind_of(SolrDocument))
      expect(subject.representation_ids).to contain_exactly(asset1.id, asset2.id)
    end
  end

  context "with a preferred representation" do
    let!(:asset1) { create(:asset, preferred_representation_of_uris: [citi_resource.uri]) }

    it "returns solr documents and ids" do
      expect(subject.preferred_representations).to contain_exactly(kind_of(SolrDocument))
      expect(subject.preferred_representation_ids).to contain_exactly(asset1.id)
      expect(subject.preferred_representation_id).to eq(asset1.id)
    end
  end

  context "with documents" do
    let!(:asset1) { create(:asset, document_of_uris: [citi_resource.uri]) }
    let!(:asset2) { create(:asset, document_of_uris: [citi_resource.uri]) }

    it "returns solr documents and ids" do
      expect(subject.documents).to include(kind_of(SolrDocument))
      expect(subject.document_ids).to contain_exactly(asset1.id, asset2.id)
    end
  end

  context "with attachments" do
    let!(:attachment) { create(:asset) }
    let!(:asset1)     { create(:asset, attachment_of_uris: [attachment.uri]) }
    let!(:asset2)     { create(:asset, attachment_of_uris: [attachment.uri]) }

    subject { described_class.new(attachment) }

    it "returns solr documents and ids" do
      expect(subject.attachments).to include(kind_of(SolrDocument))
      expect(subject.attachment_ids).to contain_exactly(asset1.id, asset2.id)
    end
  end

  context "with a nil id" do
    subject { described_class.new(nil) }

    its(:representations) { is_expected.to be_empty }
    its(:representation_ids) { is_expected.to be_empty }
    its(:preferred_representations) { is_expected.to be_empty }
    its(:preferred_representation_ids) { is_expected.to be_empty }
    its(:documents) { is_expected.to be_empty }
    its(:document_ids) { is_expected.to be_empty }
    its(:attachments) { is_expected.to be_empty }
    its(:attachment_ids) { is_expected.to be_empty }
  end
end
