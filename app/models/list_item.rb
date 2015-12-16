class ListItem < ActiveFedora::Base
  include Hydra::PCDM::ObjectBehavior
  include ResourceMetadata

  type [AICType.Resource, AICType.ListItem]
end
