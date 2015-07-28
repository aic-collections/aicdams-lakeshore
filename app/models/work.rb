class Work < ActiveFedora::Base
  include WorkMetadata
  include NestedWorkMetadata
  include Sufia::GenericFile::Metadata
  include AssetMetadata
  include Validations

  type [AICType.Work, AICType.Resource]

  def self.indexer
    ::WorkIndexer
  end

  def self.visibility
    "open"
  end

end
