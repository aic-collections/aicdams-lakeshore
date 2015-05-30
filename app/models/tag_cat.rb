class TagCat < ActiveFedora::Base
  include Sufia::GenericFile::Permissions
  include Hydra::WithDepositor

  type ::AICType.TagCat

  has_many :aictags, inverse_of: :tagcats, class_name: "Tag"

  # TODO: include from Resource metadata? or overkill?
  property :pref_label, predicate: ::RDF::SKOS.prefLabel, multiple: false do |index|
      index.as :stored_searchable
  end

  # This is coming from Sufia::GenericFile::Metadata but including the whole thing might be overkill
  property :depositor, predicate: ::RDF::URI.new("http://id.loc.gov/vocabulary/relators/dpt"), multiple: false do |index|
    index.as :symbol, :stored_searchable
  end

end
