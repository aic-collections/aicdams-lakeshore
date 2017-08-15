# frozen_string_literal: true
require 'rails_helper'

describe ListOptionsService do
  let(:list) do
    List.new.tap do |list|
      list.type << RDF::URI("http://my.list")
    end
  end

  let(:list_item) { create(:list_item, pref_label: "My list item") }

  before do
    list.save
    list.members << list_item
    list.save
  end

  it "builds a hash of list items and URIs for a given list" do
    expect(described_class.call(RDF::URI("http://my.list"))).to eq("My list item" => list_item.uri.to_s)
  end
end
