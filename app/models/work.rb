class Work < ActiveFedora::Base
  include WorkMetadata
  include NestedWorkMetadata

  type [AICType.Work, AICType.Resource]

end
