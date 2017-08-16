# frozen_string_literal: true
require 'rails_helper'

describe Shipment do
  describe "RDF types" do
    subject { described_class.new.type }
    it { is_expected.to include(AICType.Shipment,
                                AICType.Resource,
                                AICType.CitiResource,
                                Hydra::PCDM::Vocab::PCDMTerms.Object,
                                Hydra::Works::Vocab::WorksTerms.Work) }
  end

  describe "terms" do
    subject { described_class.new }
    ShipmentPresenter.terms.each do |term|
      it { is_expected.to respond_to(term) }
    end
  end
end
