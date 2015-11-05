class List < ActiveFedora::Base
  include Hydra::PCDM::ObjectBehavior
  include ResourceMetadata

  type [AICType.Resource, AICType.List]

end
