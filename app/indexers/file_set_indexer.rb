# frozen_string_literal: true
class FileSetIndexer < CurationConcerns::FileSetIndexer
  include IndexingBehaviors
  include IndexesDepositors

  def generate_solr_document
    super.tap do |solr_doc|
      solr_doc[Solrizer.solr_name("file_size", :stored_sortable, type: :integer)] = object.file_size[0]
      solr_doc[Solrizer.solr_name("image_height", :searchable, type: :integer)] = Integer(object.height.first) if object.height.present?
      solr_doc[Solrizer.solr_name("image_width", :searchable, type: :integer)] = Integer(object.width.first) if object.width.present?
      solr_doc[Solrizer.solr_name("rdf_types", :symbol)] = object.type.map(&:to_s)
    end
  end
end
