class RDFIndexingService < ActiveFedora::RDF::IndexingService
  protected

    def field_map_class
      FieldMap
    end
end
