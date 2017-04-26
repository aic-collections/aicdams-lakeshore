# frozen_string_literal: true
class CollectionPresenter < Sufia::CollectionPresenter
  def permission_badge_class
    PermissionBadge
  end
end
