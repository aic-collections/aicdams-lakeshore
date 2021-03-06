# frozen_string_literal: true
# This stands in for an object to be created from the BatchUploadForm.
# It should never actually be persisted in the repository.
# The properties on this form should be copied to a real work type.
class BatchUploadItem < Resource
  include ::CurationConcerns::WorkBehavior
  include ::CurationConcerns::BasicMetadata
  include Sufia::WorkBehavior
  include StillImageMetadata
  include TextMetadata
  include AssetMetadata

  # This mocks out the behavior of Hydra::PCDM::PcdmBehavior
  def in_collection_ids
    []
  end

  def create_or_update
    raise "This is a read only record"
  end
end
