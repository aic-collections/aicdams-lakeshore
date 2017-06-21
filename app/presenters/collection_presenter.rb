# frozen_string_literal: true
class CollectionPresenter < Sufia::CollectionPresenter
  delegate :publish_channels, :collection_type, to: :solr_document

  def self.terms
    [:total_items, :size, :publish_channels, :collection_type]
  end

  def permission_badge_class
    PermissionBadge
  end
end
