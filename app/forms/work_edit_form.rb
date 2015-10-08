class WorkEditForm < WorkPresenter
  include HydraEditor::Form
  include NestedAttributes

  self.terms = ResourceTerms.related_asset_ids + [:asset_ids]
end
