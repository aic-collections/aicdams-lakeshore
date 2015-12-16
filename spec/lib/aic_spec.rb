require 'rails_helper'

describe AIC do
  it "has a uri" do
    expect(described_class.to_uri.to_s).to eql("http://definitions.artic.edu/ontology/1.0/")
  end

  it "has defined terms" do
    expect(described_class.actorType).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.artistUid).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.batchUid).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.birthDate).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.birthYear).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.captureDevice).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.category).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.citiUid).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.citiUid).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.compositing).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.conservationDocType).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.content).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.contributor).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.created).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.createdBy).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.creatorDisplay).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.creditLine).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.dateDisplay).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.deathDate).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.deathYear).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.deptUid).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.deptCreated).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.digitizationSource).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.dimensionsDisplay).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.documentType).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.earliestDate).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.earliestYear).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.endDate).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.exhibitionHistory).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.galleryLocation).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.hasComment).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.hasConstituent).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.hasDocument).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.hasPreferredRepresentation).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.hasRepresentation).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.inscriptions).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.latestDate).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.latestYear).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.legacyUid).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.legacyUid).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.lightType).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.mainRefNumber).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.mediumDisplay).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.nameOfficial).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.nameWorking).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.objectType).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.placeOfOriginUid).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.provenanceText).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.publicationHistory).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.publVerLevel).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.specialImageType).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.startDate).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.status).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.tag).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.transcript).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.exhibitionTypeUid).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.uid).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.updated).to be_kind_of RDF::Vocabulary::Term
    expect(described_class.view).to be_kind_of RDF::Vocabulary::Term
  end
end
