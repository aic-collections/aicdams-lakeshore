require 'rails_helper'

describe AICType do
  it "has a uri" do
    expect(described_class.to_uri.to_s).to eql("http://definitions.artic.edu/ontology/1.0/type/")
  end

  it "has defined terms" do
    expect(described_class.Actor).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.Annotation).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.Asset).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.CitiResource).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.Comment).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.CommentCategory).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.CompositingType).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.ConservationDocumentType).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.ConservationImageType).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.ConservationMetadata).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.Department).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.DigitizationSource).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.DocumentType).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.Exhibition).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.LightType).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.List).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.ListItem).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.MetadataSet).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.Resource).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.Shipment).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.StatusType).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.StillImage).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.Tag).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.Text).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.Transaction).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.User).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.ViewType).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.Work).to be_kind_of RDF::Vocabulary::Term
  end
end
