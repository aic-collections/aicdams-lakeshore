# frozen_string_literal: true
require 'rails_helper'

describe Work do
  describe "intial RDF types" do
    subject { described_class.new.type }
    it { is_expected.to include(AICType.Work,
                                AICType.Resource,
                                AICType.CitiResource,
                                Hydra::PCDM::Vocab::PCDMTerms.Object,
                                Hydra::Works::Vocab::WorksTerms.Work) }
  end

  describe "metadata" do
    subject { described_class.new }
    context "defined in the presenter" do
      WorkPresenter.terms.each do |term|
        it { is_expected.to respond_to(term) }
      end
    end
  end

  describe "cardinality" do
    (WorkPresenter.model_terms - [:artist, :department, :dimensions_display]).each do |term|
      it "limits #{term} to a single value" do
        expect(described_class.properties[term.to_s].multiple?).to be false
      end
    end
  end
end
