require 'rails_helper'

describe CitiResource do
  describe "RDF type" do
    subject { described_class.new.type }
    it { is_expected.to contain_exactly(AICType.Resource, AICType.CitiResource) }
  end

  describe "terms" do
    CitiResourceTerms.all.each do |term|
      it { is_expected.to respond_to(term) }
    end
  end

  describe "#citi_uid" do
    before { subject.citi_uid = "foo" }
    its(:citi_uid) { is_expected.to eq("foo") }
  end
end
