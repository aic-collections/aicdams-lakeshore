require 'rails_helper'

describe MetadataSet do

  describe "RDF types" do
    subject { described_class.new.type }
    it { is_expected.to contain_exactly(AICType.Resource, AICType.MetadataSet) }
  end

end
