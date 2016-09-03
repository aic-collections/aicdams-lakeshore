# frozen_string_literal: true
require 'rails_helper'

describe Transaction do
  describe "RDF type" do
    subject { described_class.new.type }
    it { is_expected.to include(AICType.Transaction,
                                AICType.Resource,
                                AICType.CitiResource,
                                Hydra::PCDM::Vocab::PCDMTerms.Object,
                                Hydra::Works::Vocab::WorksTerms.Work) }
  end

  describe "terms" do
    subject { described_class.new }
    TransactionPresenter.terms.each do |term|
      it { is_expected.to respond_to(term) }
    end
  end
end
