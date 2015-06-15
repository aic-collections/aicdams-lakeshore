class GenericFile < ActiveFedora::Base
  include Sufia::GenericFile
  include Validations
  include AssetMetadata
  include NestedMetadata
  
  validate :write_once_only_fields, on: :update
  after_save :uid_matches_id, on: :create

  type AICType.Asset

end
