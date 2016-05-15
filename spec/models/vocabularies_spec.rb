# frozen_string_literal: true
require 'rails_helper'

describe BaseVocabulary do
  context "with any defined list" do
    before do
      class SampleVocab < BaseVocabulary
        def self.query
          List.find_by_label("Sample Vocabulary")
        end
      end
    end

    after do
      Object.send(:remove_const, :SampleVocab)
    end

    let!(:vocab) { create(:list, pref_label: "Sample Vocabulary") }

    describe "::all" do
      subject { SampleVocab.all }
      its(:first) { is_expected.to be_kind_of(ListItem) }
    end

    describe "::options" do
      subject { SampleVocab.options }
      its(:keys) { is_expected.to eq(["Item 1"]) }
      its(:values) { is_expected.to include(kind_of(RDF::URI)) }
    end
  end

  context "with specific defined lists" do
    describe Status do
      describe "#members" do
        subject { described_class.all }
        its(:first) { is_expected.to be_kind_of(StatusType) }
      end
    end
  end
end
