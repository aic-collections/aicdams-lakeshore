# frozen_string_literal: true
class CollectionPresenter < Sufia::CollectionPresenter
  delegate :publish_channels, to: :solr_document

  def self.terms
    super + [:publish_channels]
  end

  def permission_badge_class
    PermissionBadge
  end
end
