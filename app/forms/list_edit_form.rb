# frozen_string_literal: true
class ListEditForm
  include HydraEditor::Form
  include HydraEditor::Form::Permissions

  delegate :permissions, to: :model

  self.model_class = List

  # We're not editing any terms, only editing permissions
  self.terms = []
end
