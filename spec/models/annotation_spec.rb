require 'rails_helper'

describe Annotation do

  describe "RDF types" do
    subject { Annotation.new.type }
    it { is_expected.to include(AICType.Annotation, AICType.Resource) }
  end

end
