# frozen_string_literal: true
require 'rails_helper'

describe CollectionForm do
  let(:collection) { build(:collection) }
  let(:ability)    { Ability.new(nil) }
  let(:form)       { described_class.new(collection, ability) }

  describe "::terms" do
    subject { described_class }
    its(:terms) { is_expected.to include(:publish_channel_uris) }
  end

  subject { form }

  it { is_expected.to delegate_method(:depositor).to(:model) }
  it { is_expected.to delegate_method(:dept_created).to(:model) }
  it { is_expected.to delegate_method(:permissions).to(:model) }

  its(:primary_terms) { is_expected.to contain_exactly(:title, :publish_channel_uris) }

  describe "#disabled?" do
    context "when using :only" do
      subject { form.disabled?(:publish_channels) }
      it { is_expected.to be(true) }
    end

    context "without any restrictions" do
      subject { form.disabled?(:title) }
      it { is_expected.to be(false) }
    end

    context "with an unlisted field" do
      subject { form.disabled?(:bogus) }
      it { is_expected.to be(false) }
    end
  end

  describe "#uris_for" do
    subject { form.uris_for(:publish_channel_uris) }
    context "with no items" do
      it { is_expected.to be_empty }
    end
    context "with an array of RDF::URI items" do
      let(:term) { create(:list_item) }
      before { allow(collection).to receive(:publish_channel_uris).and_return([term]) }
      it { is_expected.to eq([term.uri.to_s]) }
    end
  end
end
