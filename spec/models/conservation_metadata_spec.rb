require 'rails_helper'

describe ConservationMetadata do
  describe "RDF types" do
    subject { described_class.new.type }
    it { is_expected.to contain_exactly(AICType.Resource, AICType.MetadataSet, AICType.ConservationMetadata) }
  end

  describe "terms" do
    subject { described_class.new }
    ConservationMetadataPresenter.terms.each do |term|
      it { is_expected.to respond_to(term) }
    end
  end
end
