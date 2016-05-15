# frozen_string_literal: true
class ListItem < ActiveFedora::Base
  include Hydra::PCDM::ObjectBehavior
  include BasicMetadata

  type [AICType.Resource, AICType.ListItem]
end
