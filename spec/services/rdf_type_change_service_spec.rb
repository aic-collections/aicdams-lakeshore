# frozen_string_literal: true
require 'rails_helper'

describe RDFTypeChangeService do
  let(:resource)  { create(:original_file_set) }
  let(:new_types) { [AICType.IntermediateFileSet, AICType.CompositingType] }
  let(:service)   { described_class.new(resource, new_types) }

  it "changes the rdf types of a resource" do
    expect(resource.type.map(&:to_s)).to contain_exactly("http://pcdm.org/models#Object",
                                                         "http://fedora.info/definitions/v4/repository#Container",
                                                         "http://www.w3.org/ns/ldp#Container",
                                                         "http://projecthydra.org/works/models#FileSet",
                                                         "http://definitions.artic.edu/ontology/1.0/type/OriginalFileSet",
                                                         "http://fedora.info/definitions/v4/repository#Resource",
                                                         "http://www.w3.org/ns/ldp#RDFSource")
    described_class.call(resource, new_types)
    resource.reload
    expect(resource.type.map(&:to_s)).to contain_exactly("http://pcdm.org/models#Object",
                                                         "http://fedora.info/definitions/v4/repository#Container",
                                                         "http://www.w3.org/ns/ldp#Container",
                                                         "http://projecthydra.org/works/models#FileSet",
                                                         "http://definitions.artic.edu/ontology/1.0/type/IntermediateFileSet",
                                                         "http://definitions.artic.edu/ontology/1.0/type/CompositingType",
                                                         "http://fedora.info/definitions/v4/repository#Resource",
                                                         "http://www.w3.org/ns/ldp#RDFSource")
  end

  context "when there are no types to delete" do
    before { allow(service).to receive(:types_to_delete).and_return([]) }

    it "does not perform an update" do
      expect(service).not_to receive(:sparql_update)
      expect(service.delete).to eq(service)
    end
  end

  context "when there are no types to add" do
    before { allow(service).to receive(:types_to_add).and_return([]) }

    it "does not perform an update" do
      expect(service).not_to receive(:sparql_update)
      expect(service.insert).to eq(service)
    end
  end

  context "when there are no types to add or delete" do
    before do
      allow(service).to receive(:types_to_delete).and_return([])
      allow(service).to receive(:types_to_add).and_return([])
    end

    it "does not perform any updates" do
      expect(service).not_to receive(:sparql_update)
      expect(service.delete.insert).to eq(service)
    end
  end
end
