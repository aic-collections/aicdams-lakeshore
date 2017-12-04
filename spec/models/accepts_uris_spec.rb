# frozen_string_literal: true
require 'rails_helper'

describe AcceptsUris do
  before(:all) do
    class UriTestClass < ActiveFedora::Base
      include AcceptsUris

      property :single_resource, predicate: ::RDF::URI("http://single_resource"),
                                 class_name: "ActiveFedora::Base", multiple: false

      property :multi_resource, predicate: ::RDF::URI("http://multi_resource"),
                                class_name: "ActiveFedora::Base", multiple: true

      accepts_uris_for :single_resource, :multi_resource
    end
  end

  after(:all) do
    Object.send(:remove_const, :UriTestClass) if defined?(UriTestClass)
  end

  let(:work) { UriTestClass.new }
  let(:item) { create(:list_item) }

  subject { work }

  context "using a multi-valued term" do
    context "with a string" do
      before { work.multi_resource_uris = [item.uri.to_s] }
      its(:multi_resource) { is_expected.to contain_exactly(item) }
      its(:multi_resource_uris) { is_expected.to contain_exactly(item.uri.to_s) }
    end

    context "with a RDF::URI" do
      before { work.multi_resource_uris = [item.uri] }
      its(:multi_resource) { is_expected.to contain_exactly(item) }
      its(:multi_resource_uris) { is_expected.to contain_exactly(item.uri.to_s) }
    end

    context "with a singular value" do
      it "raises an ArgumentError" do
        expect { work.multi_resource_uris = item.uri }.to raise_error(ArgumentError)
      end
    end

    context "with empty strings" do
      before { work.multi_resource_uris = [""] }
      its(:multi_resource) { is_expected.to be_empty }
      its(:multi_resource_uris) { is_expected.to be_empty }
    end

    context "with empty arrays" do
      before { work.multi_resource_uris = [] }
      its(:multi_resource) { is_expected.to be_empty }
      its(:multi_resource_uris) { is_expected.to be_empty }
    end

    context "with existing values" do
      before { work.multi_resource_uris = [item.uri.to_s] }
      it "uses a null set to remote them" do
        expect(subject.multi_resource).not_to be_empty
        work.multi_resource_uris = []
        expect(subject.multi_resource).to be_empty
      end
    end
  end

  context "using a single-valued term" do
    context "with a string" do
      before { work.single_resource_uri = item.uri.to_s }
      its(:single_resource) { is_expected.to eq(item) }
      its(:single_resource_uri) { is_expected.to eq(item.uri.to_s) }
    end

    context "with a RDF::URI" do
      before { work.single_resource_uri = item.uri }
      its(:single_resource) { is_expected.to eq(item) }
      its(:single_resource_uri) { is_expected.to eq(item.uri.to_s) }
    end

    context "with an empty string" do
      before { work.single_resource_uri = "" }
      its(:single_resource) { is_expected.to be_nil }
      its(:single_resource_uri) { is_expected.to be_nil }
    end

    context "with an existing value" do
      before { work.single_resource_uri = item.uri }

      it "uses nil to remove it" do
        expect { work.single_resource_uri = nil }.to change { work.single_resource }.to(nil)
      end

      it "uses an empty string to remove it" do
        expect { work.single_resource_uri = "" }.to change { work.single_resource }.to(nil)
      end
    end
  end
end
