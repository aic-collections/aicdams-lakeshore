require 'rails_helper'

describe AIC do

  it "has a uri" do
    expect(AIC.to_uri.to_s).to eql("http://definitions.artic.edu/ontology/1.0/")
  end

  it "has defined terms" do
    expect(AIC.actorType).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.artistUid).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.batchUid).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.birthDate).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.birthYear).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.captureDevice).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.category).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.citiUid).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.citiUid).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.compositing).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.conservationDocType).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.content).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.contributor).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.created).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.createdBy).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.creatorDisplay).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.creditLine).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.dateDisplay).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.deathDate).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.deathYear).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.deptUid).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.deptCreated).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.digitizationSource).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.dimensionsDisplay).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.documentType).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.earliestDate).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.earliestYear).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.endDate).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.exhibitionHistory).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.galleryLocation).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.hasComment).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.hasConstituent).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.hasDocument).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.hasPreferredRepresentation).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.hasRepresentation).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.inscriptions).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.latestDate).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.latestYear).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.legacyUid).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.legacyUid).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.lightType).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.mainRefNumber).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.mediumDisplay).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.nameOfficial).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.nameWorking).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.objectType).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.placeOfOriginUid).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.provenanceText).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.publicationHistory).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.publVerLevel).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.specialImageType).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.startDate).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.status).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.tag).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.transcript).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.exhibitionTypeUid).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.uid).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.updated).to be_kind_of RDF::Vocabulary::Term
    expect(AIC.view).to be_kind_of RDF::Vocabulary::Term
  end

end
