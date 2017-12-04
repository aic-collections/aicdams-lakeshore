# frozen_string_literal: true
require 'rails_helper'

describe BasicMetadata do
  before(:all) do
    class BasicMetadataClass < ActiveFedora::Base
      include BasicMetadata
    end
  end

  after(:all) do
    Object.send(:remove_const, :BasicMetadataClass) if defined?(UriTestClass)
  end

  subject { BasicMetadataClass.new }

  it { is_expected.to respond_to(:description) }
  it { is_expected.to respond_to(:pref_label) }
  it { is_expected.to respond_to(:uid) }

  describe "::find_by_label" do
    before do
      klass = BasicMetadataClass.new(pref_label: "A Foos List")
      klass.save
    end

    subject { BasicMetadataClass.find_by_label(label) }

    context "with an exact search" do
      let(:label) { "A Foos List" }
      its(:pref_label) { is_expected.to eq(label) }
    end

    context "with a fuzzy search" do
      let(:label) { "Foos List" }
      it { is_expected.to be_nil }
    end
  end

  describe "::find_by_uid" do
    before do
      klass = BasicMetadataClass.new(uid: "BMC-1")
      klass.save
    end

    subject { BasicMetadataClass.find_by_uid(uid) }

    context "with an exact search" do
      let(:uid) { "BMC-1" }
      its(:uid) { is_expected.to eq(uid) }
    end

    context "with a fuzzy search" do
      let(:uid) { "BMC" }
      it { is_expected.to be_nil }
    end
  end
end
