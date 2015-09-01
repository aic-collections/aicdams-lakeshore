class Resource < ActiveFedora::Base
  include ResourceMetadata
  include Validations

  def self.aic_type
    [AICType.Resource]
  end

  type aic_type
  
end
