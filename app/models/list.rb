class List < ActiveFedora::Base
  include Hydra::PCDM::ObjectBehavior
  include ResourceMetadata

  type [AICType.Resource, AICType.List]

  validate :list_item_uniqness, on: [:update]

  def list_item_uniqness
    labels = members.map(&:pref_label)
    return unless labels.detect { |l| labels.count(l) > 1 }
    errors.add :members, "must be unique"
  end
end
