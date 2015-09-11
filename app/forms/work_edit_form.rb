class WorkEditForm < WorkPresenter
  include HydraEditor::Form
  include NestedAttributes

  self.terms = ResourcePresenter.assets
end
