# frozen_string_literal: true
require 'rails_helper'

describe CurationConcerns::GenericWorkForm do
  let(:user1)   { create(:user1) }
  let(:work)    { GenericWork.new }
  let(:ability) { Ability.new(user1) }
  let(:form)    { described_class.new(work, ability) }

  describe "#required_fields" do
    subject { form.required_fields }
    it { is_expected.to contain_exactly(:asset_type, :document_type_uris) }
  end

  describe "#secondary_terms" do
    subject { form.secondary_terms }
    it { is_expected.to be_empty }
  end

  describe "::model_attributes" do
    subject { described_class.model_attributes(attributes) }
    context "with arrays of empty strings" do
      let(:attributes) { ActionController::Parameters.new(collection_ids: [""], document_type_uris: [""]) }
      it { is_expected.to eq("collection_ids" => [], "document_type_uris" => []) }
    end
  end
end
