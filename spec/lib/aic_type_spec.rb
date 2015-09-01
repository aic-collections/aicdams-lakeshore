require 'rails_helper'

describe AICType do

  it "has a uri" do
    expect(AICType.to_uri.to_s).to eql("http://definitions.artic.edu/ontology/1.0/type/")
  end

  it "has defined terms" do
    expect(AICType.Actor).to be_kind_of RDF::Vocabulary::Term
    expect(AICType.Annotation).to be_kind_of RDF::Vocabulary::Term
    expect(AICType.Asset).to be_kind_of RDF::Vocabulary::Term
    expect(AICType.CitiResource).to be_kind_of RDF::Vocabulary::Term
    expect(AICType.Comment).to be_kind_of RDF::Vocabulary::Term
    expect(AICType.ConservationMetadata).to be_kind_of RDF::Vocabulary::Term
    expect(AICType.Exhibition).to be_kind_of RDF::Vocabulary::Term
    expect(AICType.List).to be_kind_of RDF::Vocabulary::Term
    expect(AICType.ListItem).to be_kind_of RDF::Vocabulary::Term
    expect(AICType.MetadataSet).to be_kind_of RDF::Vocabulary::Term
    expect(AICType.Resource).to be_kind_of RDF::Vocabulary::Term
    expect(AICType.Shipment).to be_kind_of RDF::Vocabulary::Term
    expect(AICType.StillImage).to be_kind_of RDF::Vocabulary::Term
    expect(AICType.Text).to be_kind_of RDF::Vocabulary::Term
    expect(AICType.Transaction).to be_kind_of RDF::Vocabulary::Term
    expect(AICType.Work).to be_kind_of RDF::Vocabulary::Term
  end

end
