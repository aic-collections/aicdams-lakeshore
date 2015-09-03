require 'rails_helper'

describe Annotation do

  describe "RDF types" do
    subject { described_class.new.type }
    it { is_expected.to contain_exactly(AICType.Annotation, AICType.Resource) }
  end

end
