class Work < CitiResource
  include WorkMetadata
  include Sufia::GenericFile::Featured
  include WorkPermissions

  def self.aic_type
    super << AICType.Work
  end

  type aic_type

  def self.indexer
    ::WorkIndexer
  end

  def self.visibility
    "open"
  end

end
