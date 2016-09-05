# frozen_string_literal: true
require 'rails_helper'

describe Exhibition do
  describe "RDF type" do
    subject { described_class.new.type }
    it { is_expected.to include(AICType.Exhibition,
                                AICType.Resource,
                                AICType.CitiResource,
                                Hydra::PCDM::Vocab::PCDMTerms.Object,
                                Hydra::Works::Vocab::WorksTerms.Work) }
  end

  describe "terms" do
    subject { described_class.new }
    ExhibitionPresenter.terms.each do |term|
      it { is_expected.to respond_to(term) }
    end
  end

  describe "cardinality" do
    [:start_date, :end_date, :name_official, :name_working, :exhibition_type].each do |term|
      it "limits #{term} to a single value" do
        expect(described_class.properties[term.to_s].multiple?).to be false
      end
    end
  end

  describe "#pref_label" do
    subject { build(:exhibition, :with_sample_metadata) }
    its(:pref_label) { is_expected.to eq("EX-2846") }
  end
end
