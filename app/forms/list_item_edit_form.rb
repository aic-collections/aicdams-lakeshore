class ListItemEditForm
  include HydraEditor::Form

  self.model_class = ListItem
  self.terms = [:pref_label, :description]

end
