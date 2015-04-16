class GenericFile < ActiveFedora::Base

  include Sufia::GenericFile

  # This is an aictype:Resource

  property :aic_type, predicate: ::RDF::DC.type do |index|
    index.as :stored_searchable
  end
  property :coverage, predicate: ::RDF::DC.coverage do |index|
    index.as :stored_searchable
  end
  property :date, predicate: ::RDF::DC.date do |index|
    index.as :stored_searchable
  end
  property :format, predicate: ::RDF::DC.format do |index|
    index.as :stored_searchable
  end
  property :relation, predicate: ::RDF::DC.relation do |index|
    index.as :stored_searchable
  end
  property :pref_label, predicate: ::RDF::SKOS.prefLabel do |index|
    index.as :stored_searchable
  end  
  property :batch_uid, predicate: ::AIC.batchUid do |index|
    index.as :stored_searchable
  end 
  property :dept_created, predicate: ::AIC.deptCreated do |index|
    index.as :stored_searchable
  end 
  property :has_comment, predicate: ::AIC.hasComment do |index|
    index.as :stored_searchable
  end 
  property :has_location, predicate: ::AIC.hasLocation do |index|
    index.as :stored_searchable
  end 
  property :has_metadata, predicate: ::AIC.hasMetadata do |index|
    index.as :stored_searchable
  end 
  property :has_publishing_context, predicate: ::AIC.hasPublishingContext do |index|
    index.as :stored_searchable
  end 
  property :has_tag, predicate: ::AIC.hasTag do |index|
    index.as :stored_searchable
  end 
  property :uid, predicate: ::AIC.uid do |index|
    index.as :stored_searchable
  end 

end
