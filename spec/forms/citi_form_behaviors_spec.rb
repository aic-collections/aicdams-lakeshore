# frozen_string_literal: true
require 'rails_helper'

describe CitiFormBehaviors do
  let(:user1)    { create(:user1) }
  let(:resource) { build(:non_asset) }
  let(:ability)  { Ability.new(user1) }
  let(:form)     { NonAssetForm.new(resource, ability) }

  before(:all) do
    class NonAssetForm < CurationConcerns::Forms::WorkForm
      self.model_class = NonAsset
      include CitiFormBehaviors
    end
  end

  after(:all) do
    Object.send(:remove_const, :NonAssetForm) if defined?(NonAssetForm)
  end

  subject { form }

  describe "::terms" do
    subject { NonAssetForm }
    its(:terms) { is_expected.to include(:document_ids, :representation_ids, :preferred_representation_id) }
  end

  describe "::build_permitted_params" do
    subject { NonAssetForm }
    its(:build_permitted_params) { is_expected.to include({ document_ids: [] }, representation_ids: []) }
  end

  it { is_expected.to delegate_method(:documents).to(:inbound_asset_reference) }
  it { is_expected.to delegate_method(:document_ids).to(:inbound_asset_reference) }
  it { is_expected.to delegate_method(:preferred_representation_id).to(:inbound_asset_reference) }

  describe "#preferred_representation" do
    context "without a preferred representation" do
      its(:preferred_representation) { is_expected.to be_kind_of(SolrDocument) }
    end

    context "with a preferred representation" do
      let(:mock_reference) { double(InboundAssetReference) }
      let(:mock_representaion) { SolrDocument.new }

      before do
        allow(form).to receive(:inbound_asset_reference).and_return(mock_reference)
        allow(mock_reference).to receive(:preferred_representation).and_return(mock_representaion)
      end

      its(:preferred_representation) { is_expected.to be_kind_of(SolrDocument) }
    end
  end

  describe "#representations" do
    let(:mock_reference) { double(InboundAssetReference) }
    let(:mock_representaion) { SolrDocument.new }
    let(:mock_preferred_representaion) { SolrDocument.new }

    before do
      allow(form).to receive(:inbound_asset_reference).and_return(mock_reference)
      allow(mock_reference).to receive(:representations).and_return([mock_representaion])
    end

    context "without a preferred representation" do
      before do
        allow(mock_reference).to receive(:preferred_representation).and_return(nil)
      end

      its(:representations) { is_expected.to contain_exactly(mock_representaion) }
    end

    context "with a preferred representation" do
      before do
        allow(mock_reference).to receive(:preferred_representation).and_return(mock_preferred_representaion)
      end

      its(:representations) { is_expected.to eq([mock_preferred_representaion, mock_representaion]) }
    end
  end

  describe "#preferred_representation_thumbnail" do
    let(:default_thumbnail) { "/assets/work-ff055336041c3f7d310ad69109eda4a887b16ec501f35afc0a547c4adb97ee72.png" }
    its(:preferred_representation_thumbnail) { is_expected.to eq(default_thumbnail) }
  end
end
