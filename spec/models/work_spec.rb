require 'rails_helper'

describe Work do
  describe "intial RDF types" do
    subject { described_class.new.type }
    it { is_expected.to contain_exactly(AICType.Work, AICType.CitiResource, AICType.Resource) }
  end

  describe "metadata" do
    subject { described_class.new }
    context "defined in the presenter" do
      WorkPresenter.terms.each do |term|
        it { is_expected.to respond_to(term) }
      end
    end
  end

  it_behaves_like "a model for a Citi resource"
  it_behaves_like "an unfeatureable model"
end
