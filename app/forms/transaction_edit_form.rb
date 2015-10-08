class TransactionEditForm < TransactionPresenter
  include HydraEditor::Form
  include NestedAttributes

  self.terms = ResourceTerms.related_asset_ids
end
