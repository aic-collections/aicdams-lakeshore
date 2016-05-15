# frozen_string_literal: true
# TODO: Delete
class RDFIndexingService < ActiveFedora::RDF::IndexingService
  protected

    def field_map_class
      FieldMap
    end
end
