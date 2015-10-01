class Work < CitiResource
  include WorkMetadata
  include Sufia::GenericFile::Featured
  include CitiBehaviors

  def self.aic_type
    super << AICType.Work
  end

  type aic_type

  def featureable?
    true
  end

end
