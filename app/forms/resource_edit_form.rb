class ResourceEditForm < ResourcePresenter
  include HydraEditor::Form
  include HydraEditor::Form::Permissions
  include NestedAttributes
  self.required_fields = [:title, :creator, :tag, :rights]
end
