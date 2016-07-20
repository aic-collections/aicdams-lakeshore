# frozen_string_literal: true
require 'rails_helper'

describe CurationConcerns::GenericWorkForm do
  let(:user1)   { create(:user1) }
  let(:work)    { build(:asset) }
  let(:ability) { Ability.new(user1) }
  let(:form)    { described_class.new(work, ability) }

  subject { form }

  describe "delegates" do
    it { is_expected.to delegate_method(:dept_created).to(:model) }
  end

  describe "#required_fields" do
    its(:required_fields) { is_expected.to contain_exactly(:asset_type, :document_type_uris) }
  end

  describe "#secondary_terms" do
    its(:secondary_terms) { is_expected.to be_empty }
  end

  describe "#asset_type" do
    its(:asset_type) { is_expected.to eq(AICType.StillImage) }
  end

  describe "::model_attributes" do
    subject { described_class.model_attributes(attributes) }
    context "with arrays of empty strings" do
      let(:attributes) { ActionController::Parameters.new(collection_ids: [""], document_type_uris: [""]) }
      it { is_expected.to eq("collection_ids" => [], "document_type_uris" => []) }
    end
  end

  describe "#uris_for" do
    subject { form.uris_for(:document_type) }
    context "with no items" do
      it { is_expected.to be_empty }
    end
    context "with an array of RDF::URI items" do
      let(:term) { create(:list_item) }
      before { allow(work).to receive(:document_type).and_return([term]) }
      it { is_expected.to eq([term.uri.to_s]) }
    end
  end

  describe "#uri_for" do
    subject { form.uri_for(:compositing) }
    context "with no items" do
      it { is_expected.to be_nil }
    end
    context "with a RDF::URI item" do
      let(:term) { create(:list_item) }
      before { allow(work).to receive(:compositing).and_return(term) }
      it { is_expected.to eq(term.uri.to_s) }
    end
  end
end
