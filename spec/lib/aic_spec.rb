require 'rails_helper'

describe AIC do

  it "has defined terms" do
    expect(AIC.batchUid).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.deptCreated).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.hasComment).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.hasLocation).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.hasMetadata).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.hasPublishingContext).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.hasTag).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.uid).to be_kind_of RDF::Vocabulary::Term
  end

end
