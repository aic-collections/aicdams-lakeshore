class WorkEditForm < WorkPresenter
  include HydraEditor::Form
  include NestedAttributes

  self.terms = [:asset_ids] + WorkPresenter.terms
end
