class Work < ActiveFedora::Base
  include WorkMetadata
  include NestedWorkMetadata
  include Sufia::GenericFile::Metadata
  include AssetMetadata
  include Validations

  type [AICType.Work, AICType.Resource]

end
