require 'rails_helper'

describe CitiResource do

  describe "RDF type" do
    subject { described_class.new.type }
    it { is_expected.to contain_exactly(AICType.Resource, AICType.CitiResource) }
  end

  describe "terms" do
    subject { described_class.new }
    CitiResourcePresenter.terms.each do |term|
      it { is_expected.to respond_to(term) }
    end
  end

end
