class TagCatEditForm < TagCatPresenter
  include HydraEditor::Form
  include HydraEditor::Form::Permissions
  self.required_fields = [:pref_label]
end
