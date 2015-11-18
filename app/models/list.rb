class List < ActiveFedora::Base
  include Hydra::PCDM::ObjectBehavior
  include ResourceMetadata

  type [AICType.Resource, AICType.List]

  validate :list_item_uniqness, on: [:update]

  def list_item_uniqness
    labels = self.members.map { |s| s.pref_label }
    if labels.detect { |l| labels.count(l) > 1 }
      self.errors.add :members, "must be unique"
    end
  end

end
