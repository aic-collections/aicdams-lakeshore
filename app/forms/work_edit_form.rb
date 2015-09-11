class WorkEditForm < WorkPresenter
  include HydraEditor::Form
  include NestedAttributes

  self.terms = ResourcePresenter.assets + [:asset_ids]
end
